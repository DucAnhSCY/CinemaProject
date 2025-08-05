package com.N07.CinemaProject.repository;

import com.N07.CinemaProject.entity.SeatHold;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface SeatHoldRepository extends JpaRepository<SeatHold, Long> {
    
    List<SeatHold> findByScreeningIdAndExpiresAtAfter(Long screeningId, LocalDateTime now);
    
    List<SeatHold> findByUserSession(String userSession);
    
    Optional<SeatHold> findBySeatIdAndScreeningId(Long seatId, Long screeningId);
    
    @Modifying
    @Query("DELETE FROM SeatHold sh WHERE sh.expiresAt < :now")
    void deleteExpiredHolds(@Param("now") LocalDateTime now);
    
    @Modifying
    @Query("DELETE FROM SeatHold sh WHERE sh.userSession = :userSession")
    void deleteByUserSession(@Param("userSession") String userSession);
    
    @Modifying
    @Query("DELETE FROM SeatHold sh WHERE sh.seat.id IN :seatIds AND sh.screening.id = :screeningId AND sh.expiresAt < :now")
    void deleteExpiredHoldsForSeats(@Param("seatIds") List<Long> seatIds, @Param("screeningId") Long screeningId, @Param("now") LocalDateTime now);
    
    boolean existsBySeatIdAndScreeningIdAndExpiresAtAfter(Long seatId, Long screeningId, LocalDateTime now);
    
    boolean existsBySeatIdAndScreeningIdAndUserSessionNotAndExpiresAtAfter(Long seatId, Long screeningId, String userSession, LocalDateTime now);
    
    @Query("SELECT COUNT(sh) FROM SeatHold sh WHERE sh.seat.id IN :seatIds AND sh.screening.id = :screeningId AND sh.userSession != :userSession AND sh.expiresAt > :now")
    long countConflictingHolds(@Param("seatIds") List<Long> seatIds, @Param("screeningId") Long screeningId, @Param("userSession") String userSession, @Param("now") LocalDateTime now);
}
