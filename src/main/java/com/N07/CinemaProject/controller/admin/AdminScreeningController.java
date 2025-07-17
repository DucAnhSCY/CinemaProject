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

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

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
    public String screeningManagement(Model model) {
        try {
            List<Screening> screenings = screeningService.getAllScreenings();
            List<Movie> movies = movieService.getAllMovies();
            List<Theater> theaters = theaterService.getAllTheaters();
            
            model.addAttribute("screenings", screenings);
            model.addAttribute("movies", movies);
            model.addAttribute("theaters", theaters);
            model.addAttribute("totalScreenings", screenings.size());
            model.addAttribute("pageTitle", "Quản Lý Lịch Chiếu");
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi tải danh sách lịch chiếu: " + e.getMessage());
            model.addAttribute("screenings", List.of());
            model.addAttribute("movies", List.of());
            model.addAttribute("theaters", List.of());
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
                                 @ModelAttribute Screening screening,
                                 RedirectAttributes redirectAttributes) {
        try {
            Optional<Screening> existingScreening = screeningService.getScreeningById(id);
            if (existingScreening.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy lịch chiếu!");
                return "redirect:/admin/screenings";
            }

            screening.setId(id);
            screeningService.saveScreening(screening);
            redirectAttributes.addFlashAttribute("success", "Cập nhật lịch chiếu thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi khi cập nhật lịch chiếu: " + e.getMessage());
        }
        return "redirect:/admin/screenings";
    }

    @PostMapping("/delete/{id}")
    public String deleteScreening(@PathVariable Long id,
                                 RedirectAttributes redirectAttributes) {
        try {
            screeningService.deleteScreening(id);
            redirectAttributes.addFlashAttribute("success", "Xóa lịch chiếu thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi khi xóa lịch chiếu: " + e.getMessage());
        }
        return "redirect:/admin/screenings";
    }
}
