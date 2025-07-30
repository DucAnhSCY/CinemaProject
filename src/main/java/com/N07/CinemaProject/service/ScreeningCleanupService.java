package com.N07.CinemaProject.service;

import com.N07.CinemaProject.entity.Booking;
import com.N07.CinemaProject.entity.BookedSeat;
import com.N07.CinemaProject.entity.Screening;
import com.N07.CinemaProject.repository.BookedSeatRepository;
import com.N07.CinemaProject.repository.BookingRepository;
import com.N07.CinemaProject.repository.ScreeningRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class ScreeningCleanupService {
    
    @Autowired
    private ScreeningRepository screeningRepository;
    
    @Autowired
    private BookedSeatRepository bookedSeatRepository;
    
    @Autowired
    private BookingRepository bookingRepository;
    
    /**
     * Scheduled task để cleanup ghế đã đặt sau khi phim kết thúc
     * Chạy mỗi giờ để kiểm tra
     */
    @Scheduled(fixedRate = 3600000) // 1 giờ
    @Transactional
    public void cleanupFinishedScreenings() {
        LocalDateTime now = LocalDateTime.now();
        
        // Tìm các suất chiếu đã bắt đầu từ 4 giờ trước (giả sử phim dài nhất 4 giờ)
        LocalDateTime cutoffTime = now.minusHours(4);
        List<Screening> potentiallyFinishedScreenings = screeningRepository.findFinishedScreenings(cutoffTime);
        
        for (Screening screening : potentiallyFinishedScreenings) {
            // Tính thời gian kết thúc dựa trên startTime + duration
            Integer durationMin = screening.getMovie().getDurationMin();
            if (durationMin != null) {
                LocalDateTime endTime = screening.getStartTime().plusMinutes(durationMin);
                
                // Chỉ cleanup nếu phim đã thực sự kết thúc
                if (now.isAfter(endTime)) {
                    // Lấy tất cả booking cho suất chiếu này
                    List<Booking> bookings = bookingRepository.findByScreeningId(screening.getId());
                    
                    for (Booking booking : bookings) {
                        if (booking.getBookingStatus() == Booking.BookingStatus.CONFIRMED) {
                            // Chỉ cleanup những booking đã confirmed
                            // Cập nhật trạng thái thành EXPIRED
                            booking.setBookingStatus(Booking.BookingStatus.EXPIRED);
                            bookingRepository.save(booking);
                        }
                    }
                }
            }
        }
    }
    
    /**
     * Cleanup các booking RESERVED quá lâu (quá 30 phút chưa thanh toán)
     */
    @Scheduled(fixedRate = 1800000) // 30 phút
    @Transactional
    public void cleanupExpiredReservations() {
        LocalDateTime cutoff = LocalDateTime.now().minusMinutes(30);
        
        List<Booking> expiredReservations = bookingRepository.findExpiredReservations(cutoff);
        
        for (Booking booking : expiredReservations) {
            booking.setBookingStatus(Booking.BookingStatus.EXPIRED);
            bookingRepository.save(booking);
            
            // Xóa các booked seats để ghế có thể được đặt lại
            List<BookedSeat> bookedSeats = bookedSeatRepository.findByBookingId(booking.getId());
            bookedSeatRepository.deleteAll(bookedSeats);
        }
    }
}
