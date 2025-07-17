package com.N07.CinemaProject.service;

import com.N07.CinemaProject.entity.*;
import com.N07.CinemaProject.repository.*;
import com.N07.CinemaProject.dto.SeatDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
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
    
    public List<Booking> getBookingsByUser(Long userId) {
        return bookingRepository.findByUserIdOrderByBookingTimeDesc(userId);
    }
    
    public List<Booking> getBookingsByUserId(Long userId) {
        return getBookingsByUser(userId);
    }
    
    public Optional<Booking> getBookingById(Long id) {
        return bookingRepository.findById(id);
    }
    
    @Transactional
    public Booking createBooking(Long userId, Long screeningId, List<Long> seatIds) {
        // Kiểm tra ghế có bị đặt chưa
        for (Long seatId : seatIds) {
            if (bookedSeatRepository.existsBySeatIdAndScreeningId(seatId, screeningId)) {
                throw new RuntimeException("Ghế đã được đặt");
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
        booking.setTotalAmount(screening.getTicketPrice().multiply(BigDecimal.valueOf(seatIds.size())));
        
        booking = bookingRepository.save(booking);
        
        // Tạo booked seats
        for (Long seatId : seatIds) {
            // Get the actual seat from the database
            Seat seat = seatRepository.findById(seatId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy ghế với ID: " + seatId));
            
            BookedSeat bookedSeat = new BookedSeat();
            bookedSeat.setBooking(booking);
            bookedSeat.setSeat(seat);
            bookedSeat.setScreening(screening);
            bookedSeatRepository.save(bookedSeat);
        }
        
        return booking;
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
        
        // Chuyển đổi sang DTO với thông tin trạng thái
        return allSeats.stream()
            .map(seat -> new SeatDTO(
                seat.getId(),
                seat.getRowNumber(),
                seat.getSeatPosition(),
                seat.getSeatType(),
                bookedSeatIds.contains(seat.getId())
            ))
            .collect(Collectors.toList());
    }
    
    public List<Booking> getAllBookings() {
        return bookingRepository.findAll();
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
}
