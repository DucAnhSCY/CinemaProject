package com.N07.CinemaProject.controller.admin;

import com.N07.CinemaProject.entity.Movie;
import com.N07.CinemaProject.entity.Theater;
import com.N07.CinemaProject.entity.Screening;
import com.N07.CinemaProject.entity.Auditorium;
import com.N07.CinemaProject.service.MovieService;
import com.N07.CinemaProject.service.TheaterService;
import com.N07.CinemaProject.service.ScreeningService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.http.ResponseEntity;

import java.math.BigDecimal;
import java.util.*;

@Controller
@RequestMapping("/admin/screenings")
@PreAuthorize("hasRole('ADMIN') or hasRole('THEATER_MANAGER')")
public class AdminScreeningController {

    @Autowired
    private ScreeningService screeningService;

    @Autowired
    private MovieService movieService;

    @Autowired
    private TheaterService theaterService;

    @GetMapping
    public String screeningManagement(@RequestParam(value = "sortBy", defaultValue = "startTime") String sortBy,
                                      @RequestParam(value = "movieId", required = false) Long movieId,
                                      Model model) {
        try {
            List<Screening> screenings;
            
            // Filter by movie if specified
            if (movieId != null) {
                screenings = screeningService.getScreeningsByMovie(movieId);
            } else {
                screenings = screeningService.getAllScreenings();
            }
            
            // Sort screenings
            switch (sortBy) {
                case "movie":
                    screenings.sort((s1, s2) -> s1.getMovie().getTitle().compareToIgnoreCase(s2.getMovie().getTitle()));
                    break;
                case "theater":
                    screenings.sort((s1, s2) -> s1.getAuditorium().getTheater().getName()
                            .compareToIgnoreCase(s2.getAuditorium().getTheater().getName()));
                    break;
                case "price":
                    screenings.sort((s1, s2) -> s1.getTicketPrice().compareTo(s2.getTicketPrice()));
                    break;
                default: // startTime
                    screenings.sort((s1, s2) -> s1.getStartTime().compareTo(s2.getStartTime()));
            }
            
            List<Movie> movies = movieService.getAllMovies();
            List<Theater> theaters = theaterService.getAllTheaters();
            
            // Count today's screenings
            long todayScreenings = screenings.stream()
                .filter(screening -> screening.getStartTime().toLocalDate().isEqual(java.time.LocalDate.now()))
                .count();
            
            model.addAttribute("screenings", screenings);
            model.addAttribute("movies", movies);
            model.addAttribute("theaters", theaters);
            model.addAttribute("totalScreenings", screenings.size());
            model.addAttribute("todayScreenings", todayScreenings);
            model.addAttribute("currentSort", sortBy);
            model.addAttribute("selectedMovieId", movieId);
            model.addAttribute("pageTitle", "Quản Lý Lịch Chiếu");
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi tải danh sách lịch chiếu: " + e.getMessage());
            model.addAttribute("screenings", List.of());
            model.addAttribute("movies", List.of());
            model.addAttribute("theaters", List.of());
            model.addAttribute("todayScreenings", 0);
        }
        return "admin/screening-management";
    }

    @PostMapping("/add")
    public String addScreening(@RequestParam Long movieId,
                              @RequestParam Long auditoriumId,
                              @RequestParam String startTime,
                              @RequestParam Double ticketPrice,
                              RedirectAttributes redirectAttributes) {
        try {
            // Create new screening object
            Screening screening = new Screening();
            
            // Set movie
            Movie movie = movieService.getMovieById(movieId).orElse(null);
            if (movie == null) {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy phim!");
                return "redirect:/admin/screenings";
            }
            screening.setMovie(movie);
            
            // Set auditorium 
            Auditorium auditorium = theaterService.getAuditoriumById(auditoriumId).orElse(null);
            if (auditorium == null) {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy phòng chiếu!");
                return "redirect:/admin/screenings";
            }
            screening.setAuditorium(auditorium);
            
            // Set start time
            screening.setStartTime(java.time.LocalDateTime.parse(startTime));
            
            // Set ticket price
            screening.setTicketPrice(BigDecimal.valueOf(ticketPrice));
            
            screeningService.saveScreening(screening);
            redirectAttributes.addFlashAttribute("success", "Thêm lịch chiếu thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi khi thêm lịch chiếu: " + e.getMessage());
        }
        return "redirect:/admin/screenings";
    }

    @PostMapping("/update/{id}")
    public String updateScreening(@PathVariable Long id,
                                 @RequestParam Long movieId,
                                 @RequestParam Long auditoriumId,
                                 @RequestParam String startTime,
                                 @RequestParam Double ticketPrice,
                                 RedirectAttributes redirectAttributes) {
        try {
            Optional<Screening> existingScreening = screeningService.getScreeningById(id);
            if (existingScreening.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy lịch chiếu!");
                return "redirect:/admin/screenings";
            }

            Screening screening = existingScreening.get();
            
            // Set movie
            Movie movie = movieService.getMovieById(movieId).orElse(null);
            if (movie == null) {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy phim!");
                return "redirect:/admin/screenings";
            }
            screening.setMovie(movie);
            
            // Set auditorium 
            Auditorium auditorium = theaterService.getAuditoriumById(auditoriumId).orElse(null);
            if (auditorium == null) {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy phòng chiếu!");
                return "redirect:/admin/screenings";
            }
            screening.setAuditorium(auditorium);
            
            // Set start time
            screening.setStartTime(java.time.LocalDateTime.parse(startTime));
            
            // Set ticket price
            screening.setTicketPrice(BigDecimal.valueOf(ticketPrice));
            
            screeningService.saveScreening(screening);
            redirectAttributes.addFlashAttribute("success", "Cập nhật lịch chiếu thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi khi cập nhật lịch chiếu: " + e.getMessage());
        }
        return "redirect:/admin/screenings";
    }

    @DeleteMapping("/{id}")
    @ResponseBody
    public String deleteScreening(@PathVariable Long id) {
        try {
            screeningService.deleteScreening(id);
            return "success";
        } catch (Exception e) {
            return "error: " + e.getMessage();
        }
    }

    @PostMapping("/delete/{id}")
    public String deleteScreeningForm(@PathVariable Long id,
                                 RedirectAttributes redirectAttributes) {
        try {
            screeningService.deleteScreening(id);
            redirectAttributes.addFlashAttribute("success", "Xóa lịch chiếu thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi khi xóa lịch chiếu: " + e.getMessage());
        }
        return "redirect:/admin/screenings";
    }

    // API endpoint to get auditoriums by theater ID
    @GetMapping("/api/theaters/{theaterId}/auditoriums")
    @ResponseBody
    public List<Auditorium> getAuditoriumsByTheater(@PathVariable Long theaterId) {
        return theaterService.getAuditoriumsByTheaterId(theaterId);
    }

    // API endpoint to get screening by ID with full data
    @GetMapping("/api/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getScreeningById(@PathVariable Long id) {
        Optional<Screening> optionalScreening = screeningService.getScreeningById(id);
        if (optionalScreening.isPresent()) {
            Screening screening = optionalScreening.get();
            
            // Create response map with all needed data
            Map<String, Object> response = new HashMap<>();
            response.put("id", screening.getId());
            response.put("startTime", screening.getStartTime());
            response.put("ticketPrice", screening.getTicketPrice());
            
            // Movie data
            if (screening.getMovie() != null) {
                Map<String, Object> movieData = new HashMap<>();
                movieData.put("id", screening.getMovie().getId());
                movieData.put("title", screening.getMovie().getTitle());
                movieData.put("posterUrl", screening.getMovie().getPosterUrl());
                movieData.put("imageUrl", screening.getMovie().getImageUrl());
                response.put("movie", movieData);
            }
            
            // Auditorium and Theater data
            if (screening.getAuditorium() != null) {
                Map<String, Object> auditoriumData = new HashMap<>();
                auditoriumData.put("id", screening.getAuditorium().getId());
                auditoriumData.put("name", screening.getAuditorium().getName());
                
                if (screening.getAuditorium().getTheater() != null) {
                    Map<String, Object> theaterData = new HashMap<>();
                    theaterData.put("id", screening.getAuditorium().getTheater().getId());
                    theaterData.put("name", screening.getAuditorium().getTheater().getName());
                    auditoriumData.put("theater", theaterData);
                }
                response.put("auditorium", auditoriumData);
            }
            
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}
