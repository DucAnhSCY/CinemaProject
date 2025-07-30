package com.N07.CinemaProject.service;

import com.N07.CinemaProject.entity.*;
import com.N07.CinemaProject.repository.*;
import com.N07.CinemaProject.dto.SeatDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.persistence.criteria.Join;
import jakarta.persistence.criteria.Predicate;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class BookingService {
    
    @Autowired
    private BookingRepository bookingRepository;
    
    @Autowired
    private BookedSeatRepository bookedSeatRepository;
    
    @Autowired
    private ScreeningRepository screeningRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private SeatRepository seatRepository;
    
    @Autowired
    private SeatHoldService seatHoldService;
    
    public List<Booking> getBookingsByUser(Long userId) {
        return bookingRepository.findByUserIdOrderByBookingTimeDesc(userId);
    }
    
    public List<Booking> getBookingsByUserId(Long userId) {
        return getBookingsByUser(userId);
    }
    
    @Transactional(readOnly = true)
    public Optional<Booking> getBookingById(Long id) {
        // Load main booking with most relationships
        Optional<Booking> bookingOpt = bookingRepository.findByIdWithAllRelationships(id);
        
        if (bookingOpt.isPresent()) {
            Booking booking = bookingOpt.get();
            
            // Load booked seats separately to avoid DISTINCT issue
            List<BookedSeat> bookedSeats = bookingRepository.findBookedSeatsByBookingId(id);
            booking.setBookedSeats(bookedSeats);
            
            // Debug: Print booking seats info
            System.out.println("🔍 Debug - Booking ID: " + id);
            System.out.println("🔍 BookedSeats count: " + (booking.getBookedSeats() != null ? booking.getBookedSeats().size() : "null"));
            if (booking.getBookedSeats() != null) {
                for (BookedSeat bs : booking.getBookedSeats()) {
                    System.out.println("🔍 Seat: " + (bs.getSeat() != null ? bs.getSeat().getName() : "null seat"));
                }
            }
        }
        
        return bookingOpt;
    }
    
    @Transactional
    public Booking createBooking(Long userId, Long screeningId, List<Long> seatIds, String userSession) {
        // Kiểm tra ghế có bị đặt chưa hoặc đang được hold bởi user khác
        for (Long seatId : seatIds) {
            if (bookedSeatRepository.existsBySeatIdAndScreeningId(seatId, screeningId)) {
                throw new RuntimeException("Ghế đã được đặt");
            }
            if (seatHoldService.isSeatUnavailable(seatId, screeningId)) {
                // Kiểm tra xem có phải hold của chính user này không
                List<SeatHold> userHolds = seatHoldService.getUserHolds(userSession);
                boolean isUserOwnHold = userHolds.stream()
                    .anyMatch(hold -> hold.getSeat().getId().equals(seatId) && 
                             hold.getScreening().getId().equals(screeningId) &&
                             !hold.isExpired());
                
                if (!isUserOwnHold) {
                    throw new RuntimeException("Ghế đang được giữ chỗ bởi người dùng khác");
                }
            }
        }
        
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng"));
        
        Screening screening = screeningRepository.findById(screeningId)
            .orElseThrow(() -> new RuntimeException("Không tìm thấy suất chiếu"));
        
        // Tạo booking
        Booking booking = new Booking();
        booking.setUser(user);
        booking.setScreening(screening);
        booking.setBookingTime(LocalDateTime.now());
        booking.setBookingStatus(Booking.BookingStatus.RESERVED);
        
        // Tính tổng tiền dựa trên loại ghế
        BigDecimal totalAmount = BigDecimal.ZERO;
        BigDecimal basePrice = screening.getTicketPrice();
        
        for (Long seatId : seatIds) {
            Seat seat = seatRepository.findById(seatId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy ghế"));
            
            BigDecimal seatPrice = seat.calculatePrice(basePrice);
            totalAmount = totalAmount.add(seatPrice);
        }
        
        booking.setTotalAmount(totalAmount.setScale(2, RoundingMode.HALF_UP));
        
        booking = bookingRepository.save(booking);
        
        // Tạo booked seats
        for (Long seatId : seatIds) {
            Seat seat = seatRepository.findById(seatId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy ghế với ID: " + seatId));
            
            BookedSeat bookedSeat = new BookedSeat();
            bookedSeat.setBooking(booking);
            bookedSeat.setSeat(seat);
            bookedSeat.setScreening(screening);
            bookedSeatRepository.save(bookedSeat);
        }
        
        // Xóa hold sau khi tạo booking thành công
        seatHoldService.releaseHoldsByUserSession(userSession);
        
        return booking;
    }
    
    // Overload method để tương thích với code cũ
    @Transactional
    public Booking createBooking(Long userId, Long screeningId, List<Long> seatIds) {
        return createBooking(userId, screeningId, seatIds, "session-" + System.currentTimeMillis());
    }
    
    @Transactional
    public Booking confirmBooking(Long bookingId) {
        Booking booking = bookingRepository.findById(bookingId)
            .orElseThrow(() -> new RuntimeException("Không tìm thấy booking"));
        
        booking.setBookingStatus(Booking.BookingStatus.CONFIRMED);
        return bookingRepository.save(booking);
    }
    
    public List<BookedSeat> getBookedSeatsByScreening(Long screeningId) {
        return bookedSeatRepository.findByScreeningId(screeningId);
    }
    
    public List<Seat> getAvailableSeats(Long screeningId) {
        // Lấy tất cả ghế trong auditorium của screening
        Screening screening = screeningRepository.findById(screeningId)
            .orElseThrow(() -> new RuntimeException("Không tìm thấy suất chiếu"));
        
        List<Seat> allSeats = seatRepository.findByAuditoriumId(screening.getAuditorium().getId());
        
        // Lấy danh sách ghế đã được đặt
        List<BookedSeat> bookedSeats = bookedSeatRepository.findByScreeningId(screeningId);
        
        // Lọc ra những ghế chưa được đặt
        List<Long> bookedSeatIds = bookedSeats.stream()
            .map(bs -> bs.getSeat().getId())
            .toList();
        
        return allSeats.stream()
            .filter(seat -> !bookedSeatIds.contains(seat.getId()))
            .toList();
    }
    
    public List<SeatDTO> getSeatsWithStatus(Long screeningId) {
        // Lấy tất cả ghế trong auditorium của screening
        Screening screening = screeningRepository.findById(screeningId)
            .orElseThrow(() -> new RuntimeException("Không tìm thấy suất chiếu"));
        
        List<Seat> allSeats = seatRepository.findByAuditoriumId(screening.getAuditorium().getId());
        
        // Lấy danh sách ghế đã được đặt
        List<BookedSeat> bookedSeats = bookedSeatRepository.findByScreeningId(screeningId);
        List<Long> bookedSeatIds = bookedSeats.stream()
            .map(bs -> bs.getSeat().getId())
            .collect(Collectors.toList());
        
        // Lấy danh sách ghế đang được hold
        List<SeatHold> heldSeats = seatHoldService.getActiveHolds(screeningId);
        List<Long> heldSeatIds = heldSeats.stream()
            .map(hold -> hold.getSeat().getId())
            .collect(Collectors.toList());
        
        // Chuyển đổi sang DTO với thông tin trạng thái
        return allSeats.stream()
            .map(seat -> {
                boolean isBooked = bookedSeatIds.contains(seat.getId());
                boolean isHeld = heldSeatIds.contains(seat.getId());
                return new SeatDTO(
                    seat.getId(),
                    seat.getRowNumber(),
                    seat.getSeatPosition(),
                    seat.getSeatType(),
                    isBooked || isHeld, // Ghế không available nếu đã book hoặc đang hold
                    seat.getPriceMultiplier() // Thêm hệ số nhân giá
                );
            })
            .collect(Collectors.toList());
    }
    
    @Transactional(readOnly = true)
    public List<Booking> getAllBookings() {
        List<Booking> bookings = bookingRepository.findAll();
        // Force initialize lazy loaded relationships
        for (Booking booking : bookings) {
            initializeBookingRelationships(booking);
        }
        return bookings;
    }
    
    public List<Booking> getBookingsByScreening(Long screeningId) {
        return bookingRepository.findByScreeningId(screeningId);
    }
    
    public Booking save(Booking booking) {
        return bookingRepository.save(booking);
    }
    
    public void deleteBooking(Long id) {
        bookingRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public Page<Booking> searchBookings(String keyword, String status, String theater, 
                                      String startDate, String endDate, Pageable pageable) {
        Specification<Booking> spec = createBookingSpecification(keyword, status, theater, startDate, endDate);
        Page<Booking> bookings = bookingRepository.findAll(spec, pageable);
        
        // Force initialize lazy loaded relationships
        for (Booking booking : bookings.getContent()) {
            initializeBookingRelationships(booking);
        }
        
        return bookings;
    }

    public List<Booking> searchBookingsForExport(String keyword, String status, String theater, 
                                                String startDate, String endDate) {
        Specification<Booking> spec = createBookingSpecification(keyword, status, theater, startDate, endDate);
        List<Booking> bookings = bookingRepository.findAll(spec);
        
        // Force initialize lazy loaded relationships
        for (Booking booking : bookings) {
            initializeBookingRelationships(booking);
        }
        
        return bookings;
    }

    private void initializeBookingRelationships(Booking booking) {
        if (booking.getUser() != null) {
            booking.getUser().getUsername(); // Force load user
        }
        if (booking.getScreening() != null) {
            booking.getScreening().getMovie().getTitle(); // Force load screening and movie
            booking.getScreening().getAuditorium().getName(); // Force load auditorium
            booking.getScreening().getAuditorium().getTheater().getName(); // Force load theater
        }
        if (booking.getBookedSeats() != null) {
            booking.getBookedSeats().size(); // Force load booked seats
            for (BookedSeat bookedSeat : booking.getBookedSeats()) {
                bookedSeat.getSeat().getName(); // Force load seat
            }
        }
    }

    private Specification<Booking> createBookingSpecification(String keyword, String status, 
                                                            String theater, String startDate, String endDate) {
        return (root, query, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();

            // Search by keyword (customer name, email, movie title)
            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchPattern = "%" + keyword.toLowerCase() + "%";
                
                Join<Booking, User> userJoin = root.join("user");
                Join<Booking, Screening> screeningJoin = root.join("screening");
                Join<Screening, Movie> movieJoin = screeningJoin.join("movie");
                
                Predicate keywordPredicate = criteriaBuilder.or(
                    criteriaBuilder.like(criteriaBuilder.lower(userJoin.get("fullName")), searchPattern),
                    criteriaBuilder.like(criteriaBuilder.lower(userJoin.get("email")), searchPattern),
                    criteriaBuilder.like(criteriaBuilder.lower(movieJoin.get("title")), searchPattern)
                );
                predicates.add(keywordPredicate);
            }

            // Filter by status
            if (status != null && !status.trim().isEmpty() && !"ALL".equals(status)) {
                try {
                    Booking.BookingStatus bookingStatus = Booking.BookingStatus.valueOf(status);
                    predicates.add(criteriaBuilder.equal(root.get("bookingStatus"), bookingStatus));
                } catch (IllegalArgumentException e) {
                    // Invalid status, ignore filter
                }
            }

            // Filter by theater
            if (theater != null && !theater.trim().isEmpty() && !"ALL".equals(theater)) {
                Join<Booking, Screening> screeningJoin = root.join("screening");
                Join<Screening, Auditorium> auditoriumJoin = screeningJoin.join("auditorium");
                Join<Auditorium, Theater> theaterJoin = auditoriumJoin.join("theater");
                
                predicates.add(criteriaBuilder.equal(theaterJoin.get("id"), Long.parseLong(theater)));
            }

            // Filter by date range
            if (startDate != null && !startDate.trim().isEmpty()) {
                try {
                    LocalDate start = LocalDate.parse(startDate, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                    LocalDateTime startDateTime = start.atStartOfDay();
                    predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("bookingTime"), startDateTime));
                } catch (Exception e) {
                    // Invalid date format, ignore filter
                }
            }

            if (endDate != null && !endDate.trim().isEmpty()) {
                try {
                    LocalDate end = LocalDate.parse(endDate, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                    LocalDateTime endDateTime = end.atTime(23, 59, 59);
                    predicates.add(criteriaBuilder.lessThanOrEqualTo(root.get("bookingTime"), endDateTime));
                } catch (Exception e) {
                    // Invalid date format, ignore filter
                }
            }

            return criteriaBuilder.and(predicates.toArray(new Predicate[0]));
        };
    }
}
