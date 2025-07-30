package com.N07.CinemaProject.repository;

import com.N07.CinemaProject.entity.Booking;
import com.N07.CinemaProject.entity.BookedSeat;
import com.N07.CinemaProject.entity.Booking.BookingStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Long>, JpaSpecificationExecutor<Booking> {
    
    List<Booking> findByUserIdOrderByBookingTimeDesc(Long userId);
    
    List<Booking> findByScreeningId(Long screeningId);
    
    List<Booking> findByBookingStatus(BookingStatus status);
    
    @Query("SELECT b FROM Booking b WHERE b.bookingStatus = :status AND b.bookingTime <= :expireTime")
    List<Booking> findExpiredReservations(@Param("status") BookingStatus status, @Param("expireTime") LocalDateTime expireTime);
    
    @Query("SELECT b FROM Booking b WHERE b.bookingStatus = 'RESERVED' AND b.bookingTime <= :expireTime")
    List<Booking> findExpiredReservations(@Param("expireTime") LocalDateTime expireTime);
    
    @Query("SELECT b FROM Booking b " +
           "LEFT JOIN FETCH b.user " +
           "LEFT JOIN FETCH b.screening s " +
           "LEFT JOIN FETCH s.movie " +
           "LEFT JOIN FETCH s.auditorium a " +
           "LEFT JOIN FETCH a.theater " +
           "WHERE b.id = :id")
    Optional<Booking> findByIdWithAllRelationships(@Param("id") Long id);
    
    @Query("SELECT bs FROM BookedSeat bs " +
           "LEFT JOIN FETCH bs.seat " +
           "WHERE bs.booking.id = :bookingId")
    List<BookedSeat> findBookedSeatsByBookingId(@Param("bookingId") Long bookingId);
}
