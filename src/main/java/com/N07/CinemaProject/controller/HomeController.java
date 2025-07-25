package com.N07.CinemaProject.controller;

import com.N07.CinemaProject.entity.Movie;
import com.N07.CinemaProject.service.MovieService;
import com.N07.CinemaProject.service.SingleCinemaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;
import java.util.List;

@Controller
public class HomeController {
    
    @Autowired
    private MovieService movieService;
    
    @Autowired
    private SingleCinemaService singleCinemaService;
    
    @GetMapping("/")
    public String home(Model model, HttpServletRequest request) {
        model.addAttribute("currentPath", request.getRequestURI());
        try {
            // Thêm thông tin rạp cho trang chủ
            SingleCinemaService.CinemaInfo cinemaInfo = singleCinemaService.getCinemaInfo();
            model.addAttribute("cinema", cinemaInfo);
            model.addAttribute("isSingleCinema", true);
            
            List<Movie> featuredMovies = movieService.getAllMovies();
            
            // Nếu database trống hoặc ít phim, tự động fetch từ TMDB
            if (featuredMovies.isEmpty() || featuredMovies.size() < 5) {
                System.out.println("Database has " + featuredMovies.size() + " movies. Fetching from TMDB...");
                movieService.getPopularMovies(); // This will add movies to database
                featuredMovies = movieService.getAllMovies(); // Get updated list
            }
            
            // Chỉ hiển thị phim có suất chiếu tại rạp
            featuredMovies = featuredMovies.stream()
                .filter(movie -> !singleCinemaService.getScreeningsByMovie(movie).isEmpty())
                .limit(12) // Giới hạn 12 phim nổi bật
                .toList();
            
            model.addAttribute("featuredMovies", featuredMovies);
            System.out.println("Home page showing " + featuredMovies.size() + " movies with screenings");
        } catch (Exception e) {
            // Log error but don't break the page
            e.printStackTrace();
            model.addAttribute("featuredMovies", List.of());
        }
        return "pages/home";
    }
    
    @GetMapping("/search")
    public String search(@RequestParam(required = false) String title,
                        @RequestParam(required = false) String genre,
                        Model model, HttpServletRequest request) {
        model.addAttribute("currentPath", request.getRequestURI());
        try {
            // Thêm thông tin rạp
            SingleCinemaService.CinemaInfo cinemaInfo = singleCinemaService.getCinemaInfo();
            model.addAttribute("cinema", cinemaInfo);
            model.addAttribute("isSingleCinema", true);
            
            List<Movie> movies;
            if (title != null && !title.trim().isEmpty() || genre != null && !genre.trim().isEmpty()) {
                movies = movieService.searchMovies(title, genre);
            } else {
                movies = movieService.getAllMovies();
            }
            
            // Chỉ hiển thị phim có suất chiếu tại rạp
            movies = movies.stream()
                .filter(movie -> !singleCinemaService.getScreeningsByMovie(movie).isEmpty())
                .toList();
                
            model.addAttribute("movies", movies);
            model.addAttribute("searchTitle", title);
            model.addAttribute("searchGenre", genre);
        } catch (Exception e) {
            model.addAttribute("movies", List.of());
        }
        return "pages/search-results";
    }
    
    @GetMapping("/system-admin")
    public String systemAdmin() {
        return "redirect:/admin/system";
    }
    
    @GetMapping("/test-tmdb")
    @ResponseBody
    public Map<String, Object> testTmdb() {
        Map<String, Object> response = new HashMap<>();
        try {
            // Test TMDB connection by importing a few popular movies
            List<Movie> movies = movieService.getPopularMovies();
            response.put("success", true);
            response.put("message", "TMDB connection successful! Found " + movies.size() + " movies");
            response.put("count", movies.size());
            response.put("sample", movies.stream().limit(3).map(Movie::getTitle).toList());
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "TMDB connection failed: " + e.getMessage());
            response.put("error", e.getClass().getSimpleName());
        }
        return response;
    }
}
