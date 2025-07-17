package com.N07.CinemaProject.repository;

import com.N07.CinemaProject.entity.BookedSeat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BookedSeatRepository extends JpaRepository<BookedSeat, Long> {
    
    List<BookedSeat> findByScreeningId(Long screeningId);
    
    List<BookedSeat> findByBookingId(Long bookingId);
    
    @Query("SELECT bs FROM BookedSeat bs WHERE bs.screening.id = :screeningId AND bs.seat.id IN :seatIds")
    List<BookedSeat> findByScreeningAndSeatIds(@Param("screeningId") Long screeningId, @Param("seatIds") List<Long> seatIds);
    
    boolean existsBySeatIdAndScreeningId(Long seatId, Long screeningId);
}
