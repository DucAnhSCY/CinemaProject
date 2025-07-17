package com.N07.CinemaProject.controller.api;

import com.N07.CinemaProject.entity.*;
import com.N07.CinemaProject.service.*;
import com.N07.CinemaProject.repository.TheaterRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

@RestController
@RequestMapping("/api/admin")
@CrossOrigin(origins = "*")
public class AdminApiController {

    @Autowired
    private MovieService movieService;

    @Autowired
    private ScreeningService screeningService;

    @Autowired
    private BookingService bookingService;

    @Autowired
    private TheaterRepository theaterRepository;

    // Movie Management
    @GetMapping("/movies")
    public ResponseEntity<List<Movie>> getAllMovies() {
        List<Movie> movies = movieService.getAllMovies();
        return ResponseEntity.ok(movies);
    }

    @PostMapping("/movies")
    public ResponseEntity<Map<String, Object>> addMovie(@RequestBody Movie movie) {
        try {
            Movie savedMovie = movieService.saveMovie(movie);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("movie", savedMovie);
            response.put("message", "Thêm phim thành công!");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Thêm phim thất bại: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PutMapping("/movies/{id}")
    public ResponseEntity<Map<String, Object>> updateMovie(@PathVariable Long id, @RequestBody Movie movie) {
        try {
            movie.setId(id);
            Movie updatedMovie = movieService.saveMovie(movie);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("movie", updatedMovie);
            response.put("message", "Cập nhật phim thành công!");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Cập nhật phim thất bại: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @DeleteMapping("/movies/{id}")
    public ResponseEntity<Map<String, Object>> deleteMovie(@PathVariable Long id) {
        try {
            movieService.deleteMovie(id);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Xóa phim thành công!");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Xóa phim thất bại: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    // Screening Management
    @GetMapping("/screenings")
    public ResponseEntity<List<Screening>> getAllScreenings() {
        List<Screening> screenings = screeningService.getAllScreenings();
        return ResponseEntity.ok(screenings);
    }

    @GetMapping("/screenings/movie/{movieId}")
    public ResponseEntity<List<Screening>> getScreeningsByMovie(@PathVariable Long movieId) {
        List<Screening> screenings = screeningService.getScreeningsByMovie(movieId);
        return ResponseEntity.ok(screenings);
    }

    @PostMapping("/screenings")
    public ResponseEntity<Map<String, Object>> addScreening(@RequestBody Screening screening) {
        try {
            Screening savedScreening = screeningService.saveScreening(screening);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("screening", savedScreening);
            response.put("message", "Thêm suất chiếu thành công!");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Thêm suất chiếu thất bại: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @DeleteMapping("/screenings/{id}")
    public ResponseEntity<Map<String, Object>> deleteScreening(@PathVariable Long id) {
        try {
            screeningService.deleteScreening(id);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Xóa suất chiếu thành công!");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Xóa suất chiếu thất bại: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    // Booking Management
    @GetMapping("/bookings")
    public ResponseEntity<List<Booking>> getAllBookings() {
        try {
            // Get all bookings - you might want to add pagination later
            List<Booking> bookings = bookingService.getAllBookings();
            return ResponseEntity.ok(bookings);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @GetMapping("/bookings/screening/{screeningId}")
    public ResponseEntity<List<Booking>> getBookingsByScreening(@PathVariable Long screeningId) {
        try {
            List<Booking> bookings = bookingService.getBookingsByScreening(screeningId);
            return ResponseEntity.ok(bookings);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    // Dashboard Statistics
    @GetMapping("/stats/dashboard")
    public ResponseEntity<Map<String, Object>> getDashboardStats() {
        try {
            Map<String, Object> stats = new HashMap<>();
            
            // Movie count
            long movieCount = movieService.getAllMovies().size();
            stats.put("movieCount", movieCount);
            
            // You might need to implement these methods in your services
            stats.put("todayScreenings", 0); // Placeholder
            stats.put("todayBookings", 0); // Placeholder
            stats.put("todayRevenue", 0); // Placeholder
            
            return ResponseEntity.ok(stats);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    // Theater Management
    @GetMapping("/theaters")
    public ResponseEntity<List<Theater>> getAllTheaters() {
        List<Theater> theaters = theaterRepository.findAll();
        return ResponseEntity.ok(theaters);
    }

    @PostMapping("/theaters")
    public ResponseEntity<Map<String, Object>> addTheater(@RequestBody Theater theater) {
        try {
            Theater savedTheater = theaterRepository.save(theater);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("theater", savedTheater);
            response.put("message", "Thêm rạp thành công!");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Thêm rạp thất bại: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PutMapping("/theaters/{id}")
    public ResponseEntity<Map<String, Object>> updateTheater(@PathVariable Long id, @RequestBody Theater theater) {
        try {
            theater.setId(id);
            Theater updatedTheater = theaterRepository.save(theater);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("theater", updatedTheater);
            response.put("message", "Cập nhật rạp thành công!");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Cập nhật rạp thất bại: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @DeleteMapping("/theaters/{id}")
    public ResponseEntity<Map<String, Object>> deleteTheater(@PathVariable Long id) {
        try {
            theaterRepository.deleteById(id);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Xóa rạp thành công!");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Xóa rạp thất bại: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}
