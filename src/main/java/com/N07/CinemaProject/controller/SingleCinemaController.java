package com.N07.CinemaProject.controller;

import com.N07.CinemaProject.entity.Movie;
import com.N07.CinemaProject.entity.Screening;
import com.N07.CinemaProject.service.SingleCinemaService;
import com.N07.CinemaProject.service.MovieService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * Controller chính cho hệ thống 1 rạp duy nhất
 * Thay thế TheaterController cho logic đơn giản hơn
 */
@Controller
@RequestMapping("/cinema")
public class SingleCinemaController {
    
    @Autowired
    private SingleCinemaService singleCinemaService;
    
    @Autowired
    private MovieService movieService;
    
    /**
     * Hiển thị thông tin rạp chiếu phim
     */
    @GetMapping("/info")
    public String cinemaInfo(Model model, HttpServletRequest request) {
        model.addAttribute("currentPath", request.getRequestURI());
        
        try {
            SingleCinemaService.CinemaInfo cinemaInfo = singleCinemaService.getCinemaInfo();
            SingleCinemaService.CinemaStats stats = singleCinemaService.getCinemaStats();
            
            model.addAttribute("cinema", cinemaInfo);
            model.addAttribute("stats", stats);
            model.addAttribute("isSingleCinema", true);
            
            return "pages/cinema-info";
        } catch (Exception e) {
            model.addAttribute("error", "Không thể tải thông tin rạp: " + e.getMessage());
            return "redirect:/";
        }
    }
    
    /**
     * Hiển thị lịch chiếu của rạp
     */
    @GetMapping("/schedule")
    public String schedule(@RequestParam(required = false) String date,
                          @RequestParam(required = false) Long movieId,
                          Model model, HttpServletRequest request) {
        model.addAttribute("currentPath", request.getRequestURI());
        
        try {
            SingleCinemaService.CinemaInfo cinemaInfo = singleCinemaService.getCinemaInfo();
            model.addAttribute("cinema", cinemaInfo);
            
            List<Screening> screenings;
            List<Movie> allMovies = movieService.getCurrentlyShowingMovies();
            
            if (movieId != null) {
                // Lọc theo phim
                Movie selectedMovie = movieService.getMovieById(movieId).orElse(null);
                if (selectedMovie != null) {
                    screenings = singleCinemaService.getScreeningsByMovie(selectedMovie);
                    model.addAttribute("selectedMovie", selectedMovie);
                } else {
                    screenings = singleCinemaService.getThisWeekScreenings();
                }
            } else if (date != null && !date.isEmpty()) {
                // Lọc theo ngày (có thể implement sau)
                screenings = singleCinemaService.getThisWeekScreenings();
            } else {
                // Hiển thị tuần này
                screenings = singleCinemaService.getThisWeekScreenings();
            }
            
            model.addAttribute("screenings", screenings);
            model.addAttribute("movies", allMovies);
            model.addAttribute("selectedDate", date);
            model.addAttribute("selectedMovieId", movieId);
            
            return "pages/cinema-schedule";
        } catch (Exception e) {
            model.addAttribute("error", "Không thể tải lịch chiếu: " + e.getMessage());
            return "redirect:/";
        }
    }
    
    /**
     * Hiển thị danh sách phim đang chiếu tại rạp
     */
    @GetMapping("/movies")
    public String movies(@RequestParam(required = false) String genre,
                        @RequestParam(required = false) String search,
                        Model model, HttpServletRequest request) {
        model.addAttribute("currentPath", request.getRequestURI());
        
        try {
            SingleCinemaService.CinemaInfo cinemaInfo = singleCinemaService.getCinemaInfo();
            model.addAttribute("cinema", cinemaInfo);
            
            List<Movie> movies;
            
            if (search != null && !search.trim().isEmpty()) {
                movies = movieService.searchMoviesByTitle(search.trim());
            } else if (genre != null && !genre.trim().isEmpty()) {
                movies = movieService.getMoviesByGenre(genre.trim());
            } else {
                movies = movieService.getCurrentlyShowingMovies();
            }
            
            // Lọc chỉ những phim có suất chiếu tại rạp
            movies = movies.stream()
                .filter(movie -> !singleCinemaService.getScreeningsByMovie(movie).isEmpty())
                .toList();
            
            model.addAttribute("movies", movies);
            model.addAttribute("selectedGenre", genre);
            model.addAttribute("searchQuery", search);
            
            return "pages/cinema-movies";
        } catch (Exception e) {
            model.addAttribute("error", "Không thể tải danh sách phim: " + e.getMessage());
            return "redirect:/";
        }
    }
    
    /**
     * Redirect từ /theaters để tương thích với hệ thống cũ
     */
    @GetMapping("/")
    public String redirectFromTheaters() {
        return "redirect:/cinema/info";
    }
}
