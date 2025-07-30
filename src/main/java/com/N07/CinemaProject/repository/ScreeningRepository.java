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
    
    @Query("SELECT s FROM Screening s " +
           "JOIN FETCH s.movie m " +
           "JOIN FETCH s.auditorium a " +
           "JOIN FETCH a.theater t " +
           "WHERE m.id = :movieId " +
           "AND s.startTime > :startTime " +
           "ORDER BY s.startTime ASC")
    List<Screening> findByMovieIdAndStartTimeAfter(
        @Param("movieId") Long movieId, 
        @Param("startTime") LocalDateTime startTime);
    
    @Query("SELECT s FROM Screening s " +
           "JOIN FETCH s.movie m " +
           "JOIN FETCH s.auditorium a " +
           "JOIN FETCH a.theater t " +
           "WHERE m.id = :movieId " +
           "ORDER BY s.startTime ASC")
    List<Screening> findByMovieIdOrderByStartTime(@Param("movieId") Long movieId);
    
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
        
    // Thêm các method cho SingleCinemaService với JOIN FETCH để tránh N+1 queries
    @Query("SELECT s FROM Screening s " +
           "JOIN FETCH s.movie m " +
           "JOIN FETCH s.auditorium a " +
           "JOIN FETCH a.theater t " +
           "WHERE s.auditorium IN :auditoriums " +
           "ORDER BY s.startTime ASC")
    List<Screening> findByAuditoriumInOrderByStartTimeAsc(@Param("auditoriums") List<Auditorium> auditoriums);
    
    @Query("SELECT s FROM Screening s " +
           "JOIN FETCH s.movie m " +
           "JOIN FETCH s.auditorium a " +
           "JOIN FETCH a.theater t " +
           "WHERE s.auditorium IN :auditoriums " +
           "AND s.startTime BETWEEN :startTime AND :endTime " +
           "ORDER BY s.startTime ASC")
    List<Screening> findByAuditoriumInAndStartTimeBetweenOrderByStartTimeAsc(
        @Param("auditoriums") List<Auditorium> auditoriums, 
        @Param("startTime") LocalDateTime startTime, 
        @Param("endTime") LocalDateTime endTime);
    
    @Query("SELECT s FROM Screening s " +
           "JOIN FETCH s.movie m " +
           "JOIN FETCH s.auditorium a " +
           "JOIN FETCH a.theater t " +
           "WHERE s.movie = :movie " +
           "AND s.auditorium IN :auditoriums " +
           "ORDER BY s.startTime ASC")
    List<Screening> findByMovieAndAuditoriumInOrderByStartTimeAsc(
        @Param("movie") Movie movie, 
        @Param("auditoriums") List<Auditorium> auditoriums);
    
    @Query("SELECT s FROM Screening s WHERE s.startTime < :cutoffTime")
    List<Screening> findFinishedScreenings(@Param("cutoffTime") LocalDateTime cutoffTime);
}
