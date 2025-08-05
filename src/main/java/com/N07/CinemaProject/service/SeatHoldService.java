package com.N07.CinemaProject.service;

import com.N07.CinemaProject.entity.SeatHold;
import com.N07.CinemaProject.entity.Seat;
import com.N07.CinemaProject.entity.Screening;
import com.N07.CinemaProject.repository.SeatHoldRepository;
import com.N07.CinemaProject.repository.SeatRepository;
import com.N07.CinemaProject.repository.ScreeningRepository;
import com.N07.CinemaProject.repository.BookedSeatRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class SeatHoldService {
    
    @Autowired
    private SeatHoldRepository seatHoldRepository;
    
    @Autowired
    private SeatRepository seatRepository;
    
    @Autowired
    private ScreeningRepository screeningRepository;
    
    @Autowired
    private BookedSeatRepository bookedSeatRepository;
    
    @Transactional
    public boolean holdSeats(List<Long> seatIds, Long screeningId, String userSession) {
        try {
            // Xóa các hold cũ của user này trước
            releaseHoldsByUserSession(userSession);
            
            // Kiểm tra xem các ghế có đang được hold bởi user khác hoặc đã được book không
            for (Long seatId : seatIds) {
                if (isSeatUnavailableForNewUser(seatId, screeningId, userSession)) {
                    return false;
                }
            }
            
            // Tạo hold mới cho từng ghế
            LocalDateTime now = LocalDateTime.now();
            LocalDateTime expiresAt = now.plusMinutes(10); // Hold trong 10 phút
            
            for (Long seatId : seatIds) {
                Seat seat = seatRepository.findById(seatId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy ghế"));
                
                Screening screening = screeningRepository.findById(screeningId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy suất chiếu"));
                
                SeatHold seatHold = new SeatHold();
                seatHold.setSeat(seat);
                seatHold.setScreening(screening);
                seatHold.setUserSession(userSession);
                seatHold.setHoldTime(now);
                seatHold.setExpiresAt(expiresAt);
                
                seatHoldRepository.save(seatHold);
            }
            
            return true;
        } catch (Exception e) {
            return false;
        }
    }
    
    public boolean isSeatUnavailable(Long seatId, Long screeningId) {
        LocalDateTime now = LocalDateTime.now();
        
        // Kiểm tra xem ghế có đã được book không
        boolean isBooked = bookedSeatRepository.existsBySeatIdAndScreeningId(seatId, screeningId);
        
        // Kiểm tra xem ghế có đang được hold không (chưa hết hạn)
        boolean isOnHold = seatHoldRepository.existsBySeatIdAndScreeningIdAndExpiresAtAfter(
            seatId, screeningId, now);
        
        return isBooked || isOnHold;
    }
    
    public boolean isSeatUnavailableForNewUser(Long seatId, Long screeningId, String userSession) {
        LocalDateTime now = LocalDateTime.now();
        
        // Kiểm tra xem ghế có đã được book không
        boolean isBooked = bookedSeatRepository.existsBySeatIdAndScreeningId(seatId, screeningId);
        
        // Kiểm tra xem ghế có đang được hold bởi USER KHÁC không (chưa hết hạn)
        boolean isOnHoldByOthers = seatHoldRepository.existsBySeatIdAndScreeningIdAndUserSessionNotAndExpiresAtAfter(
            seatId, screeningId, userSession, now);
        
        return isBooked || isOnHoldByOthers;
    }
    
    @Transactional
    public void releaseHoldsByUserSession(String userSession) {
        seatHoldRepository.deleteByUserSession(userSession);
    }
    
    @Transactional
    public void releaseHold(Long seatId, Long screeningId) {
        seatHoldRepository.findBySeatIdAndScreeningId(seatId, screeningId)
            .ifPresent(seatHoldRepository::delete);
    }
    
    public List<SeatHold> getActiveHolds(Long screeningId) {
        LocalDateTime now = LocalDateTime.now();
        return seatHoldRepository.findByScreeningIdAndExpiresAtAfter(screeningId, now);
    }
    
    /**
     * Scheduled task để tự động xóa các hold đã hết hạn
     * Chạy mỗi phút
     */
    @Scheduled(fixedRate = 60000) // 1 phút
    @Transactional
    public void cleanupExpiredHolds() {
        LocalDateTime now = LocalDateTime.now();
        seatHoldRepository.deleteExpiredHolds(now);
    }
    
    public List<SeatHold> getUserHolds(String userSession) {
        return seatHoldRepository.findByUserSession(userSession);
    }
}
