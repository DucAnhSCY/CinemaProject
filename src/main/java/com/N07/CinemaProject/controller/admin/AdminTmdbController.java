package com.N07.CinemaProject.controller.admin;

import com.N07.CinemaProject.entity.Movie;
import com.N07.CinemaProject.service.TmdbService;
import com.N07.CinemaProject.service.MovieService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

@Controller
@RequestMapping("/admin/tmdb")
public class AdminTmdbController {

    @Autowired
    private TmdbService tmdbService;

    @Autowired
    private MovieService movieService;

    @GetMapping
    public String tmdbMovies(Model model) {
        try {
            // Get movies with TMDB IDs from local database
            List<Movie> localMovies = movieService.getAllMovies();
            List<Movie> tmdbMovies = localMovies.stream()
                    .filter(movie -> movie.getTmdbId() != null)
                    .toList();
            
            model.addAttribute("tmdbMovies", tmdbMovies);
            model.addAttribute("totalTmdbMovies", tmdbMovies.size());
            model.addAttribute("pageTitle", "TMDB Movie Management");
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi tải danh sách phim TMDB: " + e.getMessage());
            model.addAttribute("tmdbMovies", List.of());
        }
        return "admin/tmdb-movies";
    }

    @GetMapping("/search")
    public String searchTmdb(@RequestParam(required = false) String query, 
                            @RequestParam(required = false) Integer year,
                            Model model) {
        if (query != null && !query.trim().isEmpty()) {
            try {
                List<Movie> searchResults;
                if (year != null) {
                    searchResults = tmdbService.searchMovies(query.trim(), year);
                } else {
                    searchResults = tmdbService.searchMovies(query.trim());
                }
                model.addAttribute("searchResults", searchResults);
                model.addAttribute("searchQuery", query);
                model.addAttribute("searchYear", year);
                model.addAttribute("resultCount", searchResults.size());
            } catch (Exception e) {
                model.addAttribute("error", "Lỗi khi tìm kiếm: " + e.getMessage());
                model.addAttribute("searchResults", List.of());
            }
        } else if (year != null) {
            try {
                List<Movie> searchResults = tmdbService.discoverMoviesByYear(year);
                model.addAttribute("searchResults", searchResults);
                model.addAttribute("searchYear", year);
                model.addAttribute("resultCount", searchResults.size());
            } catch (Exception e) {
                model.addAttribute("error", "Lỗi khi tìm kiếm theo năm: " + e.getMessage());
                model.addAttribute("searchResults", List.of());
            }
        }
        
        // Get current TMDB movies for comparison
        try {
            List<Movie> localMovies = movieService.getAllMovies();
            List<Movie> tmdbMovies = localMovies.stream()
                    .filter(movie -> movie.getTmdbId() != null)
                    .toList();
            model.addAttribute("tmdbMovies", tmdbMovies);
        } catch (Exception e) {
            model.addAttribute("tmdbMovies", List.of());
        }
        
        return "admin/tmdb-movies";
    }

    // API endpoints for JavaScript calls
    @GetMapping("/api/search")
    @ResponseBody
    public Map<String, Object> apiSearchTmdb(@RequestParam(required = false) String query, 
                                           @RequestParam(required = false) Integer year) {
        Map<String, Object> response = new HashMap<>();
        try {
            List<Movie> searchResults;
            if (query != null && !query.trim().isEmpty()) {
                if (year != null) {
                    searchResults = tmdbService.searchMovies(query.trim(), year);
                } else {
                    searchResults = tmdbService.searchMovies(query.trim());
                }
            } else if (year != null) {
                searchResults = tmdbService.discoverMoviesByYear(year);
            } else {
                response.put("success", false);
                response.put("error", "Vui lòng nhập tên phim hoặc năm để tìm kiếm");
                return response;
            }
            
            response.put("success", true);
            response.put("results", searchResults);
            response.put("count", searchResults.size());
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("error", "Lỗi khi tìm kiếm: " + e.getMessage());
        }
        return response;
    }

    @PostMapping("/import/{tmdbId}")
    @ResponseBody
    public Map<String, Object> importFromTmdb(@PathVariable Long tmdbId) {
        Map<String, Object> response = new HashMap<>();
        try {
            // Use the service method that handles duplicates properly
            Movie movie = movieService.getOrCreateMovieByTmdbId(tmdbId);
            if (movie != null) {
                response.put("success", true);
                response.put("message", "Phim đã được thêm/cập nhật thành công từ TMDB!");
            } else {
                response.put("success", false);
                response.put("message", "Không thể lấy thông tin phim từ TMDB!");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi khi thêm phim: " + e.getMessage());
        }
        return response;
    }

    @PostMapping("/import-popular")
    @ResponseBody
    public Map<String, Object> importPopularMovies() {
        Map<String, Object> response = new HashMap<>();
        try {
            List<Movie> popularMovies = tmdbService.fetchPopularMovies();
            int importedCount = 0;
            
            for (Movie movie : popularMovies) {
                try {
                    // Use the service method that handles duplicates properly
                    if (movie.getTmdbId() != null) {
                        Movie result = movieService.getOrCreateMovieByTmdbId(movie.getTmdbId());
                        if (result != null) {
                            importedCount++;
                        }
                    }
                } catch (Exception e) {
                    // Continue with next movie if one fails
                    System.err.println("Failed to import movie: " + movie.getTitle() + " - " + e.getMessage());
                }
            }
            
            response.put("success", true);
            response.put("message", "Đã import thành công " + importedCount + " phim phổ biến từ TMDB");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi khi import phim phổ biến: " + e.getMessage());
        }
        return response;
    }

    @PostMapping("/import-now-playing")
    @ResponseBody
    public Map<String, Object> importNowPlayingMovies() {
        Map<String, Object> response = new HashMap<>();
        try {
            List<Movie> nowPlayingMovies = tmdbService.fetchNowPlayingMovies();
            int importedCount = 0;
            
            for (Movie movie : nowPlayingMovies) {
                try {
                    // Use the service method that handles duplicates properly
                    if (movie.getTmdbId() != null) {
                        Movie result = movieService.getOrCreateMovieByTmdbId(movie.getTmdbId());
                        if (result != null) {
                            importedCount++;
                        }
                    }
                } catch (Exception e) {
                    // Continue with next movie if one fails
                    System.err.println("Failed to import movie: " + movie.getTitle() + " - " + e.getMessage());
                }
            }
            
            response.put("success", true);
            response.put("message", "Đã import thành công " + importedCount + " phim đang chiếu từ TMDB");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi khi import phim đang chiếu: " + e.getMessage());
        }
        return response;
    }

    @PostMapping("/refresh/{movieId}")
    @ResponseBody
    public Map<String, Object> refreshMovieFromTmdb(@PathVariable Long movieId) {
        Map<String, Object> response = new HashMap<>();
        try {
            Movie existingMovie = movieService.getMovieById(movieId).orElse(null);
            if (existingMovie == null || existingMovie.getTmdbId() == null) {
                response.put("success", false);
                response.put("message", "Phim không tồn tại hoặc không có TMDB ID!");
                return response;
            }

            Movie updatedMovie = tmdbService.fetchMovieDetails(existingMovie.getTmdbId());
            if (updatedMovie != null) {
                // Keep the existing ID and TMDB ID
                updatedMovie.setId(existingMovie.getId());
                updatedMovie.setTmdbId(existingMovie.getTmdbId());
                movieService.saveMovie(updatedMovie);
                
                response.put("success", true);
                response.put("message", "Đã cập nhật thông tin phim từ TMDB!");
            } else {
                response.put("success", false);
                response.put("message", "Không thể lấy thông tin cập nhật từ TMDB!");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi khi cập nhật phim: " + e.getMessage());
        }
        return response;
    }

    @DeleteMapping("/{movieId}")
    @ResponseBody
    public Map<String, Object> deleteMovie(@PathVariable Long movieId) {
        Map<String, Object> response = new HashMap<>();
        try {
            movieService.deleteMovie(movieId);
            response.put("success", true);
            response.put("message", "Đã xóa phim thành công!");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi khi xóa phim: " + e.getMessage());
        }
        return response;
    }
}
