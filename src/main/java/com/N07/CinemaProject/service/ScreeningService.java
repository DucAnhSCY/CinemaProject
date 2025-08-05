package com.N07.CinemaProject.service;

import com.N07.CinemaProject.entity.Screening;
import com.N07.CinemaProject.repository.ScreeningRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.CacheEvict;
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
        // Lấy tất cả lịch chiếu không giới hạn thời gian cho admin
        List<Screening> screenings = screeningRepository.findAllWithRelatedData();
        System.out.println("ScreeningService.getAllScreenings() - Found " + screenings.size() + " screenings");
        return screenings;
    }
    
    @Cacheable(value = "activeScreenings", key = "'active'")
    public List<Screening> getActiveScreenings() {
        // Lấy chỉ các suất chiếu còn hiệu lực cho customer
        LocalDateTime now = LocalDateTime.now();
        return screeningRepository.findAllWithRelatedData()
            .stream()
            .filter(screening -> screening.getStartTime().isAfter(now))
            .toList();
    }
    
    @Cacheable(value = "screenings", key = "'today-' + T(java.time.LocalDate).now().toString()")
    public List<Screening> getTodayScreenings() {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime endOfDay = LocalDate.now().atTime(23, 59, 59);
        return screeningRepository.findTodayScreeningsWithRelatedData(now, endOfDay);
    }
    
    public Optional<Screening> getScreeningById(Long id) {
        return screeningRepository.findById(id);
    }
    
    @Cacheable(value = "screenings", key = "'movie-' + #movieId")
    public List<Screening> getScreeningsByMovie(Long movieId) {
        // Chỉ hiển thị suất chiếu còn hiệu lực cho customer
        return screeningRepository.findByMovieIdAndStartTimeAfter(movieId, LocalDateTime.now());
    }
    
    // Method mới cho admin để xem tất cả suất chiếu của một phim
    public List<Screening> getAllScreeningsByMovie(Long movieId) {
        return screeningRepository.findByMovieIdOrderByStartTime(movieId);
    }
    
    public List<Screening> getScreeningsByTheaterAndDateRange(Long theaterId, LocalDateTime start, LocalDateTime end) {
        return screeningRepository.findByAuditoriumTheaterIdAndStartTimeBetween(theaterId, start, end);
    }
    
    public List<Screening> getScreeningsByMovieAndTheater(Long movieId, Long theaterId) {
        return screeningRepository.findScreeningsByMovieAndTheaterFromDate(movieId, theaterId, LocalDateTime.now());
    }
    
    @CacheEvict(value = {"screenings", "activeScreenings"}, allEntries = true)
    public Screening saveScreening(Screening screening) {
        System.out.println("Saving screening and clearing cache...");
        return screeningRepository.save(screening);
    }
    
    @CacheEvict(value = {"screenings", "activeScreenings"}, allEntries = true)
    public void deleteScreening(Long id) {
        System.out.println("Deleting screening and clearing cache...");
        screeningRepository.deleteById(id);
    }
}
