package com.N07.CinemaProject.service;

import com.N07.CinemaProject.entity.Screening;
import com.N07.CinemaProject.repository.ScreeningRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class ScreeningService {
    
    @Autowired
    private ScreeningRepository screeningRepository;
    
    @Cacheable("screenings")
    public List<Screening> getAllScreenings() {
        return screeningRepository.findAllWithRelatedData();
    }
    
    @Cacheable(value = "screenings", key = "'today-' + T(java.time.LocalDate).now().toString()")
    public List<Screening> getTodayScreenings() {
        LocalDateTime startOfDay = LocalDate.now().atStartOfDay();
        LocalDateTime endOfDay = LocalDate.now().atTime(23, 59, 59);
        return screeningRepository.findTodayScreeningsWithRelatedData(startOfDay, endOfDay);
    }
    
    public Optional<Screening> getScreeningById(Long id) {
        return screeningRepository.findById(id);
    }
    
    @Cacheable(value = "screenings", key = "'movie-' + #movieId")
    public List<Screening> getScreeningsByMovie(Long movieId) {
        return screeningRepository.findByMovieIdAndStartTimeAfter(movieId, LocalDateTime.now());
    }
    
    public List<Screening> getScreeningsByTheaterAndDateRange(Long theaterId, LocalDateTime start, LocalDateTime end) {
        return screeningRepository.findByAuditoriumTheaterIdAndStartTimeBetween(theaterId, start, end);
    }
    
    public List<Screening> getScreeningsByMovieAndTheater(Long movieId, Long theaterId) {
        return screeningRepository.findScreeningsByMovieAndTheaterFromDate(movieId, theaterId, LocalDateTime.now());
    }
    
    public Screening saveScreening(Screening screening) {
        return screeningRepository.save(screening);
    }
    
    public void deleteScreening(Long id) {
        screeningRepository.deleteById(id);
    }
}
