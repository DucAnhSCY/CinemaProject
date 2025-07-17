package com.N07.CinemaProject.service;

import com.N07.CinemaProject.entity.Screening;
import com.N07.CinemaProject.repository.ScreeningRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class ScreeningService {
    
    @Autowired
    private ScreeningRepository screeningRepository;
    
    public List<Screening> getAllScreenings() {
        return screeningRepository.findAll();
    }
    
    public Optional<Screening> getScreeningById(Long id) {
        return screeningRepository.findById(id);
    }
    
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
