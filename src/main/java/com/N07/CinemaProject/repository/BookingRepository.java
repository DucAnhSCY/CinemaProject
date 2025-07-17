package com.N07.CinemaProject.repository;

import com.N07.CinemaProject.entity.Booking;
import com.N07.CinemaProject.entity.Booking.BookingStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Long> {
    
    List<Booking> findByUserIdOrderByBookingTimeDesc(Long userId);
    
    List<Booking> findByScreeningId(Long screeningId);
    
    List<Booking> findByBookingStatus(BookingStatus status);
    
    @Query("SELECT b FROM Booking b WHERE b.bookingStatus = :status AND b.bookingTime <= :expireTime")
    List<Booking> findExpiredReservations(@Param("status") BookingStatus status, @Param("expireTime") LocalDateTime expireTime);
}
