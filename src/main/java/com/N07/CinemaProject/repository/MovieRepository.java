package com.N07.CinemaProject.repository;

import com.N07.CinemaProject.entity.Movie;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface MovieRepository extends JpaRepository<Movie, Long> {
    
    List<Movie> findByGenreContainingIgnoreCase(String genre);
    
    List<Movie> findByTitleContainingIgnoreCase(String title);
    
    List<Movie> findByTitleContainingIgnoreCaseAndGenreContainingIgnoreCase(String title, String genre);
    
    Optional<Movie> findByTmdbId(Long tmdbId);
    
    @Query("SELECT DISTINCT m FROM Movie m JOIN m.screenings s WHERE s.startTime >= :date")
    List<Movie> findMoviesWithScreeningsFromDate(@Param("date") LocalDate date);
    
    @Query("SELECT m FROM Movie m WHERE m.releaseDate <= :currentDate ORDER BY m.releaseDate DESC")
    List<Movie> findCurrentlyShowingMovies(@Param("currentDate") LocalDate currentDate);
}
