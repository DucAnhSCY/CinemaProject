package com.N07.CinemaProject.repository;

import com.N07.CinemaProject.entity.Seat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface SeatRepository extends JpaRepository<Seat, Long> {
    
    List<Seat> findByAuditoriumId(Long auditoriumId);
    
    List<Seat> findByAuditoriumIdOrderByRowNumberAscSeatPositionAsc(Long auditoriumId);
    
    @Modifying
    @Transactional
    @Query("DELETE FROM Seat s WHERE s.auditorium.id = :auditoriumId")
    void deleteByAuditoriumId(@Param("auditoriumId") Long auditoriumId);
}
