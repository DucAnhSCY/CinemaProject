package com.N07.CinemaProject.repository;

import com.N07.CinemaProject.entity.Screening;
import com.N07.CinemaProject.entity.Auditorium;
import com.N07.CinemaProject.entity.Movie;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface ScreeningRepository extends JpaRepository<Screening, Long> {
    
    List<Screening> findByMovieIdAndStartTimeAfter(Long movieId, LocalDateTime startTime);
    
    List<Screening> findByMovieIdOrderByStartTime(Long movieId);
    
    List<Screening> findByAuditoriumTheaterIdAndStartTimeBetween(
        Long theaterId, LocalDateTime start, LocalDateTime end);
    
    @Query("SELECT s FROM Screening s WHERE s.movie.id = :movieId AND " +
           "s.auditorium.theater.id = :theaterId AND s.startTime >= :fromDate")
    List<Screening> findScreeningsByMovieAndTheaterFromDate(
        @Param("movieId") Long movieId, 
        @Param("theaterId") Long theaterId, 
        @Param("fromDate") LocalDateTime fromDate);
    
    @Query("SELECT s FROM Screening s WHERE s.startTime >= :fromTime AND s.startTime <= :toTime")
    List<Screening> findScreeningsInTimeRange(
        @Param("fromTime") LocalDateTime fromTime, 
        @Param("toTime") LocalDateTime toTime);
        
    // Thêm các method cho SingleCinemaService
    List<Screening> findByAuditoriumInOrderByStartTimeAsc(List<Auditorium> auditoriums);
    
    List<Screening> findByAuditoriumInAndStartTimeBetweenOrderByStartTimeAsc(
        List<Auditorium> auditoriums, LocalDateTime startTime, LocalDateTime endTime);
    
    List<Screening> findByMovieAndAuditoriumInOrderByStartTimeAsc(Movie movie, List<Auditorium> auditoriums);
    
    @Query("SELECT s FROM Screening s WHERE s.startTime < :cutoffTime")
    List<Screening> findFinishedScreenings(@Param("cutoffTime") LocalDateTime cutoffTime);
}
