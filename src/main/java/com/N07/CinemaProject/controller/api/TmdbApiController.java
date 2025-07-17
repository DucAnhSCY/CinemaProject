package com.N07.CinemaProject.controller.api;

import com.N07.CinemaProject.entity.Movie;
import com.N07.CinemaProject.service.MovieService;
import com.N07.CinemaProject.service.TmdbService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/tmdb")
@CrossOrigin(origins = "*")
public class TmdbApiController {
    
    @Autowired
    private TmdbService tmdbService;
    
    @Autowired
    private MovieService movieService;
    
    @GetMapping("/popular")
    public ResponseEntity<List<Movie>> getPopularMovies() {
        try {
            List<Movie> movies = movieService.getPopularMovies();
            return ResponseEntity.ok(movies);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    @GetMapping("/now-playing")
    public ResponseEntity<List<Movie>> getNowPlayingMovies() {
        try {
            List<Movie> movies = movieService.getCurrentlyShowingMovies();
            return ResponseEntity.ok(movies);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    @GetMapping("/search")
    public ResponseEntity<List<Movie>> searchMovies(@RequestParam String query) {
        try {
            List<Movie> movies = tmdbService.searchMovies(query);
            return ResponseEntity.ok(movies);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    @PostMapping("/import/{tmdbId}")
    public ResponseEntity<Map<String, Object>> importMovieFromTmdb(@PathVariable Long tmdbId) {
        try {
            Movie movie = movieService.getOrCreateMovieByTmdbId(tmdbId);
            Map<String, Object> response = new HashMap<>();
            
            if (movie != null) {
                response.put("success", true);
                response.put("movie", movie);
                response.put("message", "Phim đã được import thành công!");
            } else {
                response.put("success", false);
                response.put("message", "Không thể import phim từ TMDB");
            }
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Lỗi import phim: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    @PostMapping("/sync")
    public ResponseEntity<Map<String, Object>> syncAllMovies() {
        try {
            // Fetch and sync popular movies
            List<Movie> popularMovies = movieService.getPopularMovies();
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("syncedCount", popularMovies.size());
            response.put("message", "Đã đồng bộ " + popularMovies.size() + " phim từ TMDB");
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Lỗi đồng bộ: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}
