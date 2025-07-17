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

    // Tạo ghế tự động cho phòng chiếu
    private void createSeatsForAuditorium(Auditorium auditorium, int rows, int seatsPerRow) {
        for (int row = 0; row < rows; row++) {
            String rowNumber = String.valueOf((char) ('A' + row));
            
            for (int position = 1; position <= seatsPerRow; position++) {
                Seat seat = new Seat();
                seat.setAuditorium(auditorium);
                seat.setRowNumber(rowNumber);
                seat.setSeatPosition(position);
                
                // Phân loại ghế dựa trên vị trí
                if (row < 2) {
                    seat.setSeatType(Seat.SeatType.VIP); // 2 hàng đầu là VIP
                } else if (row >= rows - 2) {
                    seat.setSeatType(Seat.SeatType.COUPLE); // 2 hàng cuối là Couple
                } else {
                    seat.setSeatType(Seat.SeatType.STANDARD); // Các hàng giữa là Standard
                }
                
                seatRepository.save(seat);
            }
        }
    }

    // Lấy ghế của phòng chiếu
    public List<Seat> getSeatsByAuditoriumId(Long auditoriumId) {
        return seatRepository.findByAuditoriumIdOrderByRowNumberAscSeatPositionAsc(auditoriumId);
    }

    // Cập nhật layout ghế
    @Transactional
    public void updateSeatLayout(Long auditoriumId, String seatLayoutJson) {
        // TODO: Parse JSON và cập nhật seat layout
        // Có thể implement sau nếu cần thiết
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
}
