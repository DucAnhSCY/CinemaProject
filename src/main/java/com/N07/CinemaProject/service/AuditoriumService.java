package com.N07.CinemaProject.service;

import com.N07.CinemaProject.entity.Auditorium;
import com.N07.CinemaProject.entity.Seat;
import com.N07.CinemaProject.entity.Theater;
import com.N07.CinemaProject.repository.AuditoriumRepository;
import com.N07.CinemaProject.repository.SeatRepository;
import com.N07.CinemaProject.repository.TheaterRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class AuditoriumService {

    @Autowired
    private AuditoriumRepository auditoriumRepository;
    
    @Autowired
    private TheaterRepository theaterRepository;
    
    @Autowired
    private SeatRepository seatRepository;

    // Lấy tất cả phòng chiếu
    public List<Auditorium> getAllAuditoriums() {
        return auditoriumRepository.findAll();
    }

    // Lấy phòng chiếu theo theater ID
    public List<Auditorium> getAuditoriumsByTheaterId(Long theaterId) {
        return auditoriumRepository.findByTheaterId(theaterId);
    }

    // Lấy phòng chiếu theo ID
    public Optional<Auditorium> getAuditoriumById(Long id) {
        return auditoriumRepository.findById(id);
    }

    // Tạo phòng chiếu mới
    public Auditorium createAuditorium(String name, Long theaterId, int totalSeats, int rows, int seatsPerRow) {
        // Kiểm tra theater có tồn tại không
        Theater theater = theaterRepository.findById(theaterId)
                .orElseThrow(() -> new RuntimeException("Theater not found with id: " + theaterId));

        // Kiểm tra tên phòng chiếu đã tồn tại trong theater này chưa
        List<Auditorium> existingAuditoriums = auditoriumRepository.findByTheaterId(theaterId);
        boolean nameExists = existingAuditoriums.stream()
                .anyMatch(a -> a.getName().equalsIgnoreCase(name));
        
        if (nameExists) {
            throw new RuntimeException("Tên phòng chiếu đã tồn tại trong rạp này: " + name);
        }

        // Tạo auditorium mới
        Auditorium auditorium = new Auditorium();
        auditorium.setName(name);
        auditorium.setTheater(theater);
        auditorium.setTotalSeats(totalSeats);

        // Lưu auditorium trước
        auditorium = auditoriumRepository.save(auditorium);

        // Tạo ghế tự động
        createSeatsForAuditorium(auditorium, rows, seatsPerRow);

        return auditorium;
    }

    // Cập nhật phòng chiếu
    public Auditorium updateAuditorium(Long id, String name, Long theaterId, Integer totalSeats) {
        Auditorium auditorium = auditoriumRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Auditorium not found with id: " + id));

        // Kiểm tra theater có tồn tại không
        Theater theater = theaterRepository.findById(theaterId)
                .orElseThrow(() -> new RuntimeException("Theater not found with id: " + theaterId));

        // Kiểm tra tên phòng chiếu đã tồn tại trong theater này chưa (trừ chính nó)
        List<Auditorium> existingAuditoriums = auditoriumRepository.findByTheaterId(theaterId);
        boolean nameExists = existingAuditoriums.stream()
                .anyMatch(a -> a.getName().equalsIgnoreCase(name) && !a.getId().equals(id));
        
        if (nameExists) {
            throw new RuntimeException("Tên phòng chiếu đã tồn tại trong rạp này: " + name);
        }

        auditorium.setName(name);
        auditorium.setTheater(theater);
        if (totalSeats != null) {
            auditorium.setTotalSeats(totalSeats);
        }

        return auditoriumRepository.save(auditorium);
    }

    // Xóa phòng chiếu
    public void deleteAuditorium(Long id) {
        Auditorium auditorium = auditoriumRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Auditorium not found with id: " + id));

        // Kiểm tra xem có screening nào đang sử dụng phòng chiếu này không
        if (auditorium.getScreenings() != null && !auditorium.getScreenings().isEmpty()) {
            throw new RuntimeException("Không thể xóa phòng chiếu này vì đang có lịch chiếu");
        }

        auditoriumRepository.deleteById(id);
    }

    // Tạo ghế tự động cho phòng chiếu (50 ghế với 3 loại)
    private void createSeatsForAuditorium(Auditorium auditorium, int rows, int seatsPerRow) {
        // Cấu trúc ghế cho mỗi phòng 50 ghế:
        // Hàng A, B: VIP (20 ghế) - 2 hàng x 10 ghế
        // Hàng C, D, E: STANDARD (21 ghế) - 3 hàng x 7 ghế 
        // Hàng F: COUPLE (9 ghế) - 1 hàng x 9 ghế
        
        int seatCount = 0;
        
        // Hàng A, B: STANDARD (20 ghế) - hệ số x1.0
        for (int row = 0; row < 2; row++) {
            String rowNumber = String.valueOf((char) ('A' + row));
            for (int position = 1; position <= 10; position++) {
                Seat seat = new Seat();
                seat.setAuditorium(auditorium);
                seat.setRowNumber(rowNumber);
                seat.setSeatPosition(position);
                seat.setSeatType(Seat.SeatType.STANDARD);
                seat.setPriceModifier(new BigDecimal("1.00")); // Ghế thường hệ số x1.0
                seatRepository.save(seat);
                seatCount++;
            }
        }
        
        // Hàng C, D, E: VIP (21 ghế) - hệ số x1.2
        for (int row = 2; row < 5; row++) {
            String rowNumber = String.valueOf((char) ('A' + row));
            for (int position = 1; position <= 7; position++) {
                Seat seat = new Seat();
                seat.setAuditorium(auditorium);
                seat.setRowNumber(rowNumber);
                seat.setSeatPosition(position);
                seat.setSeatType(Seat.SeatType.VIP);
                seat.setPriceModifier(new BigDecimal("1.20")); // Ghế VIP hệ số x1.2
                seatRepository.save(seat);
                seatCount++;
            }
        }
        
        // Hàng F: COUPLE (9 ghế) - hệ số x1.7
        String rowNumber = "F";
        for (int position = 1; position <= 9; position++) {
            Seat seat = new Seat();
            seat.setAuditorium(auditorium);
            seat.setRowNumber(rowNumber);
            seat.setSeatPosition(position);
            seat.setSeatType(Seat.SeatType.COUPLE);
            seat.setPriceModifier(new BigDecimal("1.70")); // Ghế Couple hệ số x1.7
            seatRepository.save(seat);
            seatCount++;
        }
        
        // Cập nhật tổng số ghế trong auditorium
        auditorium.setTotalSeats(seatCount);
        auditoriumRepository.save(auditorium);
    }

    // Lấy ghế của phòng chiếu
    public List<Seat> getSeatsByAuditoriumId(Long auditoriumId) {
        return seatRepository.findByAuditoriumIdOrderByRowNumberAscSeatPositionAsc(auditoriumId);
    }

    // Cập nhật layout ghế
    @Transactional
    public void updateSeatLayout(Long auditoriumId, String seatLayoutJson) {
        
    }

    // Đếm số auditorium theo theater
    public long countAuditoriumsByTheaterId(Long theaterId) {
        return auditoriumRepository.findByTheaterId(theaterId).size();
    }

    // Kiểm tra tên auditorium có tồn tại trong theater không
    public boolean existsByNameAndTheaterId(String name, Long theaterId) {
        List<Auditorium> auditoriums = auditoriumRepository.findByTheaterId(theaterId);
        return auditoriums.stream().anyMatch(a -> a.getName().equalsIgnoreCase(name));
    }

    // Kiểm tra tên auditorium có tồn tại trong theater không (trừ ID hiện tại)
    public boolean existsByNameAndTheaterIdAndIdNot(String name, Long theaterId, Long id) {
        List<Auditorium> auditoriums = auditoriumRepository.findByTheaterId(theaterId);
        return auditoriums.stream()
                .anyMatch(a -> a.getName().equalsIgnoreCase(name) && !a.getId().equals(id));
    }
    
    /**
     * Reset lại 50 ghế cho phòng chiếu theo layout mới
     */
    public void resetSeatsForAuditorium(Long auditoriumId) {
        Optional<Auditorium> auditoriumOpt = auditoriumRepository.findById(auditoriumId);
        if (!auditoriumOpt.isPresent()) {
            throw new RuntimeException("Không tìm thấy phòng chiếu với ID: " + auditoriumId);
        }
        
        Auditorium auditorium = auditoriumOpt.get();
        
        // Xóa tất cả ghế cũ
        seatRepository.deleteByAuditoriumId(auditoriumId);
        
        // Tạo lại 50 ghế theo layout mới
        createSeatsForAuditorium(auditorium, 6, 10); // 6 hàng, 10 ghế mỗi hàng = 60 ghế, nhưng hàng F chỉ có 6 ghế
    }
    
    /**
     * Cập nhật mapping ghế cho tất cả auditorium hiện có
     */
    public void updateExistingSeatMappings() {
        List<Seat> allSeats = seatRepository.findAll();
        
        for (Seat seat : allSeats) {
            String rowNumber = seat.getRowNumber();
            
            // Mapping mới theo yêu cầu:
            // A,B → STANDARD (ghế thường x1.0)
            // C,D,E → VIP (ghế VIP x1.2) 
            // F → COUPLE (ghế đôi x1.7)
            
            if ("A".equals(rowNumber) || "B".equals(rowNumber)) {
                seat.setSeatType(Seat.SeatType.STANDARD);
                seat.setPriceModifier(new BigDecimal("1.00"));
            } else if ("C".equals(rowNumber) || "D".equals(rowNumber) || "E".equals(rowNumber)) {
                seat.setSeatType(Seat.SeatType.VIP);
                seat.setPriceModifier(new BigDecimal("1.20"));
            } else if ("F".equals(rowNumber)) {
                seat.setSeatType(Seat.SeatType.COUPLE);
                seat.setPriceModifier(new BigDecimal("1.70")); // Cập nhật hệ số x1.7
            }
            
            seatRepository.save(seat);
        }
    }
}
