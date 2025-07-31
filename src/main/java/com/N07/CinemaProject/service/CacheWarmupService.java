package com.N07.CinemaProject.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Service;

@Service
public class CacheWarmupService {
    
    @Autowired
    private MovieService movieService;
    
    @Autowired
    private ScreeningService screeningService;
    
    @Autowired
    private TheaterService theaterService;
    
    @EventListener(ApplicationReadyEvent.class)
    public void warmupCaches() {
        System.out.println("=== Starting cache warmup ===");
        long startTime = System.currentTimeMillis();
        
        try {
            // Warm up movies cache
            System.out.println("Warming up movies cache...");
            movieService.getAllMovies();
            
            // Warm up theaters cache
            System.out.println("Warming up theaters cache...");
            theaterService.getAllTheaters();
            
            // Warm up screenings cache
            System.out.println("Warming up screenings cache...");
            screeningService.getAllScreenings();
            screeningService.getTodayScreenings();
            
            long endTime = System.currentTimeMillis();
            System.out.println("=== Cache warmup completed in " + (endTime - startTime) + "ms ===");
            
        } catch (Exception e) {
            System.err.println("Error during cache warmup: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
