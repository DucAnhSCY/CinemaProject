package com.N07.CinemaProject.controller;

import com.N07.CinemaProject.entity.Movie;
import com.N07.CinemaProject.entity.Screening;
import com.N07.CinemaProject.service.MovieService;
import com.N07.CinemaProject.service.SingleCinemaService;
import com.N07.CinemaProject.service.ScreeningService;
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
import java.util.Set;
import java.util.stream.Collectors;

@Controller
public class HomeController {
    
    @Autowired
    private MovieService movieService;
    
    @Autowired
    private SingleCinemaService singleCinemaService;
    
    @Autowired
    private ScreeningService screeningService;
    
    @GetMapping("/")
    public String home(Model model, HttpServletRequest request) {
        model.addAttribute("currentPath", request.getRequestURI());
        try {
            // Thêm thông tin rạp cho trang chủ
            SingleCinemaService.CinemaInfo cinemaInfo = singleCinemaService.getCinemaInfo();
            model.addAttribute("cinema", cinemaInfo);
            model.addAttribute("isSingleCinema", true);
            
            // Tối ưu: Lấy movies có cache và giới hạn số lượng sớm
            List<Movie> allMovies = movieService.getAllMovies();
            
            // Nếu database trống, fetch từ TMDB một lần
            if (allMovies.isEmpty()) {
                System.out.println("No movies in database. Fetching from TMDB...");
                movieService.getPopularMovies(); // This will add movies to database
                allMovies = movieService.getAllMovies(); // Get updated list
            }
            
            // Tối ưu: Lấy tất cả screenings một lần thay vì gọi cho từng movie
            List<Screening> allScreenings = screeningService.getAllScreenings();
            Set<Long> movieIdsWithScreenings = allScreenings.stream()
                .map(screening -> screening.getMovie().getId())
                .collect(Collectors.toSet());
            
            // Filter movies có screening và giới hạn ngay
            List<Movie> featuredMovies = allMovies.stream()
                .filter(movie -> movieIdsWithScreenings.contains(movie.getId()))
                .limit(12) // Giới hạn 12 phim nổi bật
                .collect(Collectors.toList());
            
            model.addAttribute("featuredMovies", featuredMovies);
            
            // Lấy 4 suất chiếu của 4 phim khác nhau trong ngày hôm nay
            List<Screening> todayScreenings = getTodayFeaturedScreenings();
            model.addAttribute("featuredScreenings", todayScreenings);
            
            System.out.println("Home page showing " + featuredMovies.size() + " movies with screenings");
            System.out.println("Home page showing " + todayScreenings.size() + " featured screenings for today");
        } catch (Exception e) {
            // Log error but don't break the page
            e.printStackTrace();
            model.addAttribute("featuredMovies", List.of());
            model.addAttribute("featuredScreenings", List.of());
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
            
            // Tối ưu: Lấy tất cả screenings một lần
            List<Screening> allScreenings = screeningService.getAllScreenings();
            Set<Long> movieIdsWithScreenings = allScreenings.stream()
                .map(screening -> screening.getMovie().getId())
                .collect(Collectors.toSet());
            
            // Chỉ hiển thị phim có suất chiếu tại rạp
            movies = movies.stream()
                .filter(movie -> movieIdsWithScreenings.contains(movie.getId()))
                .toList();
                
            model.addAttribute("movies", movies);
            model.addAttribute("searchTitle", title);
            model.addAttribute("searchGenre", genre);
        } catch (Exception e) {
            model.addAttribute("movies", List.of());
        }
        return "pages/search-results";
    }
    
    /**
     * Lấy 4 suất chiếu của 4 phim khác nhau trong ngày hôm nay
     */
    private List<Screening> getTodayFeaturedScreenings() {
        try {
            // Sử dụng method tối ưu đã cache
            List<Screening> allTodayScreenings = screeningService.getTodayScreenings();
            
            // Nhóm theo phim và lấy 1 suất chiếu đầu tiên của mỗi phim
            List<Screening> featuredScreenings = allTodayScreenings.stream()
                .collect(Collectors.groupingBy(screening -> screening.getMovie().getId()))
                .values().stream()
                .map(screeningList -> screeningList.stream()
                    .sorted((s1, s2) -> s1.getStartTime().compareTo(s2.getStartTime()))
                    .findFirst().orElse(null))
                .filter(screening -> screening != null)
                .limit(4) // Chỉ lấy 4 suất chiếu
                .collect(Collectors.toList());
            
            return featuredScreenings;
        } catch (Exception e) {
            System.err.println("Error getting today's featured screenings: " + e.getMessage());
            return List.of();
        }
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
            response.put("sample", movies.stream().limit(3).map(movie -> 
                Map.of("title", movie.getTitle(), 
                       "overview", movie.getOverview() != null ? movie.getOverview() : "No overview",
                       "description", movie.getDescription() != null ? movie.getDescription() : "No description")
            ).toList());
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "TMDB connection failed: " + e.getMessage());
            response.put("error", e.getClass().getSimpleName());
        }
        return response;
    }
    
    @GetMapping("/refresh-movies")
    @ResponseBody
    public Map<String, Object> refreshMovies() {
        Map<String, Object> response = new HashMap<>();
        try {
            // Clear cache để force refresh
            System.out.println("Refreshing movies from TMDB...");
            
            // Gọi TmdbService trực tiếp để fetch movies mới
            List<Movie> movies = movieService.forceRefreshMovies();
            
            response.put("success", true);
            response.put("message", "Movies refreshed successfully! Found " + movies.size() + " movies");
            response.put("count", movies.size());
            response.put("moviesWithOverview", movies.stream()
                .filter(movie -> movie.getOverview() != null && !movie.getOverview().isEmpty())
                .count());
            response.put("sample", movies.stream().limit(3).map(movie -> 
                Map.of("title", movie.getTitle(), 
                       "hasOverview", movie.getOverview() != null && !movie.getOverview().isEmpty(),
                       "overviewLength", movie.getOverview() != null ? movie.getOverview().length() : 0)
            ).toList());
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Movies refresh failed: " + e.getMessage());
            response.put("error", e.getClass().getSimpleName());
            e.printStackTrace();
        }
        return response;
    }
}
