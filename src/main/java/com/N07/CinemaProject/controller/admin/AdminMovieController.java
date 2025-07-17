package com.N07.CinemaProject.controller.admin;

import com.N07.CinemaProject.entity.Movie;
import com.N07.CinemaProject.entity.Screening;
import com.N07.CinemaProject.entity.Theater;
import com.N07.CinemaProject.entity.Auditorium;
import com.N07.CinemaProject.service.MovieService;
import com.N07.CinemaProject.service.ScreeningService;
import com.N07.CinemaProject.service.TmdbService;
import com.N07.CinemaProject.repository.TheaterRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin/movies")
@PreAuthorize("hasRole('ADMIN') or hasRole('THEATER_MANAGER')")
public class AdminMovieController {

    @Autowired
    private MovieService movieService;

    @Autowired
    private ScreeningService screeningService;

    @Autowired
    private TheaterRepository theaterRepository;

    @Autowired
    private TmdbService tmdbService;

    @GetMapping
    public String listMovies(Model model) {
        List<Movie> movies = movieService.getAllMovies();
        model.addAttribute("movies", movies);
        return "admin/movie-management";
    }

    @GetMapping("/new")
    public String newMovieForm(Model model) {
        model.addAttribute("movie", new Movie());
        return "admin/movie-form";
    }

    @PostMapping("/new")
    public String addMovie(@ModelAttribute Movie movie, RedirectAttributes redirectAttributes) {
        try {
            movieService.saveMovie(movie);
            redirectAttributes.addFlashAttribute("success", "Đã thêm phim thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi khi thêm phim: " + e.getMessage());
        }
        return "redirect:/admin/movies";
    }

    @GetMapping("/{id}/edit")
    public String editMovieForm(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        try {
            Optional<Movie> movieOpt = movieService.getMovieById(id);
            if (movieOpt.isPresent()) {
                model.addAttribute("movie", movieOpt.get());
                return "admin/movie-form";
            } else {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy phim!");
                return "redirect:/admin/movies";
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi khi tải thông tin phim: " + e.getMessage());
            return "redirect:/admin/movies";
        }
    }

    @PostMapping("/{id}/edit")
    public String updateMovie(@PathVariable Long id, @ModelAttribute Movie movie, RedirectAttributes redirectAttributes) {
        try {
            movie.setId(id);
            movieService.saveMovie(movie);
            redirectAttributes.addFlashAttribute("success", "Đã cập nhật phim thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi khi cập nhật phim: " + e.getMessage());
        }
        return "redirect:/admin/movies";
    }

    @GetMapping("/tmdb-search")
    public String tmdbSearch(@RequestParam(required = false) String query, Model model) {
        if (query != null && !query.trim().isEmpty()) {
            try {
                List<Movie> searchResults = tmdbService.searchMovies(query);
                model.addAttribute("searchResults", searchResults);
            } catch (Exception e) {
                model.addAttribute("error", "Lỗi khi tìm kiếm phim từ TMDB: " + e.getMessage());
            }
        }
        model.addAttribute("query", query);
        return "admin/tmdb-search";
    }

    @PostMapping("/add-from-tmdb")
    public String addMovieFromTMDB(@RequestParam Long tmdbId, RedirectAttributes redirectAttributes) {
        try {
            Movie movie = tmdbService.fetchMovieDetails(tmdbId);
            movieService.saveMovie(movie);
            redirectAttributes.addFlashAttribute("success", "Đã thêm phim thành công từ TMDB!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi khi thêm phim: " + e.getMessage());
        }
        return "redirect:/admin/movies";
    }

    @GetMapping("/{id}/screenings")
    public String manageScreenings(@PathVariable Long id, Model model) {
        Optional<Movie> movieOpt = movieService.getMovieById(id);
        if (movieOpt.isEmpty()) {
            return "redirect:/admin/movies?error=Movie not found";
        }
        
        Movie movie = movieOpt.get();
        List<Theater> theaters = theaterRepository.findAll();
        List<Screening> screenings = screeningService.getScreeningsByMovie(id);
        
        model.addAttribute("movie", movie);
        model.addAttribute("theaters", theaters);
        model.addAttribute("screenings", screenings);
        return "admin/screening-management";
    }

    @PostMapping("/{id}/screenings")
    public String addScreening(@PathVariable Long id,
                              @RequestParam Long theaterId,
                              @RequestParam String startTime,
                              @RequestParam BigDecimal ticketPrice,
                              RedirectAttributes redirectAttributes) {
        try {
            Optional<Movie> movieOpt = movieService.getMovieById(id);
            Optional<Theater> theaterOpt = theaterRepository.findById(theaterId);
            
            if (movieOpt.isEmpty() || theaterOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Phim hoặc rạp chiếu không tồn tại!");
                return "redirect:/admin/movies/" + id + "/screenings";
            }
            
            // For now, we'll use the first auditorium of the theater
            Theater theater = theaterOpt.get();
            Auditorium auditorium = theater.getAuditoriums().get(0); // Simplified for now
            
            Screening screening = new Screening();
            screening.setMovie(movieOpt.get());
            screening.setAuditorium(auditorium);
            screening.setStartTime(LocalDateTime.parse(startTime));
            screening.setTicketPrice(ticketPrice);
            
            screeningService.saveScreening(screening);
            redirectAttributes.addFlashAttribute("success", "Đã thêm lịch chiếu thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi khi thêm lịch chiếu: " + e.getMessage());
            e.printStackTrace();
        }
        return "redirect:/admin/movies/" + id + "/screenings";
    }

    @DeleteMapping("/screenings/{screeningId}")
    @ResponseBody
    public String deleteScreening(@PathVariable Long screeningId) {
        try {
            screeningService.deleteScreening(screeningId);
            return "success";
        } catch (Exception e) {
            return "error";
        }
    }

    @DeleteMapping("/{id}")
    @ResponseBody
    public String deleteMovie(@PathVariable Long id) {
        try {
            movieService.deleteMovie(id);
            return "success";
        } catch (Exception e) {
            return "error";
        }
    }
}
