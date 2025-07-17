package com.N07.CinemaProject.controller.api;

import com.N07.CinemaProject.entity.Movie;
import com.N07.CinemaProject.entity.Theater;
import com.N07.CinemaProject.entity.Screening;
import com.N07.CinemaProject.service.MovieService;
import com.N07.CinemaProject.repository.TheaterRepository;
import com.N07.CinemaProject.repository.ScreeningRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.util.Optional;

@RestController
@RequestMapping("/api/movies")
@CrossOrigin(origins = "*")
public class MovieApiController {

    @Autowired
    private MovieService movieService;

    @Autowired
    private TheaterRepository theaterRepository;

    @Autowired
    private ScreeningRepository screeningRepository;

    @GetMapping
    public ResponseEntity<List<Movie>> getAllMovies() {
        List<Movie> movies = movieService.getCurrentlyShowingMovies();
        return ResponseEntity.ok(movies);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Movie> getMovieById(@PathVariable Long id) {
        Optional<Movie> movie = movieService.getMovieById(id);
        return movie.map(ResponseEntity::ok)
                   .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/search")
    public ResponseEntity<List<Movie>> searchMovies(
            @RequestParam(required = false) String title,
            @RequestParam(required = false) String genre) {
        List<Movie> movies = movieService.searchMovies(title, genre);
        return ResponseEntity.ok(movies);
    }

    @GetMapping("/{id}/screenings")
    public ResponseEntity<List<Screening>> getMovieScreenings(@PathVariable Long id) {
        List<Screening> screenings = screeningRepository.findByMovieIdOrderByStartTime(id);
        return ResponseEntity.ok(screenings);
    }

    @GetMapping("/theaters")
    public ResponseEntity<List<Theater>> getAllTheaters() {
        List<Theater> theaters = theaterRepository.findAll();
        return ResponseEntity.ok(theaters);
    }

    @PostMapping
    public ResponseEntity<Movie> createMovie(@RequestBody Movie movie) {
        try {
            Movie savedMovie = movieService.saveMovie(movie);
            return ResponseEntity.ok(savedMovie);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<Movie> updateMovie(@PathVariable Long id, @RequestBody Movie movie) {
        try {
            movie.setId(id);
            Movie updatedMovie = movieService.saveMovie(movie);
            return ResponseEntity.ok(updatedMovie);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteMovie(@PathVariable Long id) {
        try {
            movieService.deleteMovie(id);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @GetMapping("/test-tmdb")
    public ResponseEntity<Map<String, Object>> testTmdb() {
        Map<String, Object> response = new HashMap<>();
        try {
            // Test TMDB connection by importing a few popular movies
            List<Movie> movies = movieService.getPopularMovies();
            response.put("success", true);
            response.put("message", "TMDB connection successful! Found " + movies.size() + " movies");
            response.put("count", movies.size());
            response.put("sample", movies.stream().limit(3).map(Movie::getTitle).toList());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "TMDB connection failed: " + e.getMessage());
            response.put("error", e.getClass().getSimpleName());
            return ResponseEntity.internalServerError().body(response);
        }
    }

    @PostMapping("/reset-movies")
    public ResponseEntity<Map<String, Object>> resetMovies() {
        Map<String, Object> response = new HashMap<>();
        try {
            // Delete all existing movies 
            movieService.deleteAllMovies();
            
            // Import new movies from TMDB
            List<Movie> movies = movieService.getPopularMovies();
            
            response.put("success", true);
            response.put("message", "Đã reset và import " + movies.size() + " phim mới từ TMDB");
            response.put("count", movies.size());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi khi reset phim: " + e.getMessage());
            response.put("error", e.getClass().getSimpleName());
            return ResponseEntity.internalServerError().body(response);
        }
    }

    @PostMapping("/add-sample-movies")
    public ResponseEntity<Map<String, Object>> addSampleMovies() {
        Map<String, Object> response = new HashMap<>();
        try {
            // Add some sample movies with TMDB-like data
            List<Movie> sampleMovies = createSampleMovies();
            List<Movie> savedMovies = new ArrayList<>();
            
            for (Movie movie : sampleMovies) {
                Movie saved = movieService.saveMovie(movie);
                savedMovies.add(saved);
            }
            
            response.put("success", true);
            response.put("message", "Đã thêm " + savedMovies.size() + " phim mẫu");
            response.put("count", savedMovies.size());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi khi thêm phim mẫu: " + e.getMessage());
            return ResponseEntity.internalServerError().body(response);
        }
    }
    
    private List<Movie> createSampleMovies() {
        List<Movie> movies = new ArrayList<>();
        
        Movie movie1 = new Movie();
        movie1.setTitle("Oppenheimer");
        movie1.setOriginalTitle("Oppenheimer");
        movie1.setDescription("Câu chuyện về J. Robert Oppenheimer, nhà khoa học được giao nhiệm vụ phát triển bom nguyên tử trong Thế chiến II.");
        movie1.setGenre("Drama, History");
        movie1.setDurationMin(180);
        movie1.setReleaseDate(java.time.LocalDate.of(2023, 7, 21));
        movie1.setPosterUrl("https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg");
        movie1.setBackdropUrl("https://image.tmdb.org/t/p/w1280/fm6KqXpk3M2HVveHwCrBSSBaO0V.jpg");
        movie1.setVoteAverage(8.3);
        movie1.setVoteCount(6247);
        movie1.setPopularity(3456.789);
        movie1.setTmdbId(872585L);
        movie1.setOriginalLanguage("en");
        movie1.setAdult(false);
        movies.add(movie1);
        
        Movie movie2 = new Movie();
        movie2.setTitle("Barbie");
        movie2.setOriginalTitle("Barbie");
        movie2.setDescription("Barbie và Ken đang có một ngày tuyệt vời ở thế giới màu hồng, hoàn hảo của họ trong Barbieland.");
        movie2.setGenre("Comedy, Adventure");
        movie2.setDurationMin(114);
        movie2.setReleaseDate(java.time.LocalDate.of(2023, 7, 21));
        movie2.setPosterUrl("https://image.tmdb.org/t/p/w500/iuFNMS8U5cb6xfzi51Dbkovj7vM.jpg");
        movie2.setBackdropUrl("https://image.tmdb.org/t/p/w1280/nHf61UzkfFno5X1ofIhugCPus2R.jpg");
        movie2.setVoteAverage(7.1);
        movie2.setVoteCount(5896);
        movie2.setPopularity(2543.321);
        movie2.setTmdbId(346698L);
        movie2.setOriginalLanguage("en");
        movie2.setAdult(false);
        movies.add(movie2);
        
        Movie movie3 = new Movie();
        movie3.setTitle("Spider-Man: Across the Spider-Verse");
        movie3.setOriginalTitle("Spider-Man: Across the Spider-Verse");
        movie3.setDescription("Sau khi đoàn tụ với Gwen Stacy, Spider-Man thân thiện của Brooklyn được thúc đẩy khắp Đa vũ trụ.");
        movie3.setGenre("Animation, Action");
        movie3.setDurationMin(140);
        movie3.setReleaseDate(java.time.LocalDate.of(2023, 6, 2));
        movie3.setPosterUrl("https://image.tmdb.org/t/p/w500/8Vt6mWEReuy4Of61Lnj5Xj704m8.jpg");
        movie3.setBackdropUrl("https://image.tmdb.org/t/p/w1280/VuukZLgaCrho2Ar8Scl9HtV3yD.jpg");
        movie3.setVoteAverage(8.6);
        movie3.setVoteCount(4521);
        movie3.setPopularity(1987.654);
        movie3.setTmdbId(569094L);
        movie3.setOriginalLanguage("en");
        movie3.setAdult(false);
        movies.add(movie3);
        
        return movies;
    }
}
