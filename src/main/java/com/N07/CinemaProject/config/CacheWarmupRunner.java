package com.N07.CinemaProject.config;

import com.N07.CinemaProject.service.MovieService;
import com.N07.CinemaProject.service.TheaterService;
import com.N07.CinemaProject.service.ScreeningService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

@Component
public class CacheWarmupRunner implements ApplicationRunner {

    @Autowired
    private MovieService movieService;
    
    @Autowired
    private TheaterService theaterService;
    
    @Autowired
    private ScreeningService screeningService;

    @Override
    public void run(ApplicationArguments args) throws Exception {
        System.out.println("Warming up cache...");
        
        // Warm up theaters cache
        theaterService.getAllTheaters();
        
        // Warm up movies cache  
        movieService.getAllMovies();
        
        // Warm up today's screenings cache
        screeningService.getTodayScreenings();
        
        System.out.println("Cache warmup completed.");
    }
}
