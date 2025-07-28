package com.N07.CinemaProject.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import com.N07.CinemaProject.repository.UserRepository;
import com.N07.CinemaProject.repository.BookingRepository;
import com.N07.CinemaProject.repository.MovieRepository;
import com.N07.CinemaProject.service.SingleCinemaService;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/admin")
@PreAuthorize("hasRole('ADMIN') or hasRole('THEATER_MANAGER')")
public class AdminController {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private BookingRepository bookingRepository;
    
    @Autowired
    private MovieRepository movieRepository;
    
    @Autowired
    private SingleCinemaService singleCinemaService;

    @GetMapping("")
    public String adminDashboard(Model model) {
        try {
            // Thống kê cho hệ thống 1 rạp duy nhất
            SingleCinemaService.CinemaStats cinemaStats = singleCinemaService.getCinemaStats();
            model.addAttribute("cinemaStats", cinemaStats);
            
            // Các thống kê khác
            long totalUsers = userRepository.count();
            long totalMovies = movieRepository.count();
            long totalBookings = bookingRepository.count();
            
            model.addAttribute("totalUsers", totalUsers);
            model.addAttribute("totalMovies", totalMovies);
            model.addAttribute("totalBookings", totalBookings);
            
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi tải thống kê: " + e.getMessage());
        }
        
        model.addAttribute("pageTitle", "Admin Dashboard");
        return "admin/dashboard";
    }

    @GetMapping("/system")
    @PreAuthorize("hasRole('ADMIN')")
    public String systemAdmin(Model model) {
        model.addAttribute("pageTitle", "Quản Trị Hệ Thống");
        return "system-admin";
    }

    @GetMapping("/cinema")
    public String cinemaAdmin(Model model) {
        try {
            SingleCinemaService.CinemaInfo cinemaInfo = singleCinemaService.getCinemaInfo();
            model.addAttribute("cinemaInfo", cinemaInfo);
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi tải thông tin rạp: " + e.getMessage());
        }
        model.addAttribute("pageTitle", "Quản Lý Rạp Chiếu");
        return "admin/cinema-management";
    }

    @GetMapping("/reports")
    public String reportsPage(Model model) {
        try {
            // Thống kê cho hệ thống 1 rạp
            SingleCinemaService.CinemaStats cinemaStats = singleCinemaService.getCinemaStats();
            long totalUsers = userRepository.count();
            long totalBookings = bookingRepository.count();
            long totalMovies = movieRepository.count();
            
            model.addAttribute("cinemaStats", cinemaStats);
            model.addAttribute("totalUsers", totalUsers);
            model.addAttribute("totalBookings", totalBookings);
            model.addAttribute("totalMovies", totalMovies);
            model.addAttribute("pageTitle", "Báo Cáo Thống Kê");
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi tải báo cáo: " + e.getMessage());
        }
        return "admin/reports";
    }
    
    // API endpoints
    @GetMapping("/api/dashboard-stats")
    @ResponseBody
    public Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();
        try {
            SingleCinemaService.CinemaStats cinemaStats = singleCinemaService.getCinemaStats();
            stats.put("cinemaName", cinemaStats.getName());
            stats.put("totalAuditoriums", cinemaStats.getTotalAuditoriums());
            stats.put("totalSeats", cinemaStats.getTotalSeats());
            stats.put("totalUsers", userRepository.count());
            stats.put("totalMovies", movieRepository.count());
            stats.put("totalBookings", bookingRepository.count());
        } catch (Exception e) {
            stats.put("error", "Lỗi khi tải thống kê: " + e.getMessage());
        }
        return stats;
    }
    
    @GetMapping("/api/users")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public Object getUsers() {
        return userRepository.findAll();
    }
    
    @GetMapping("/api/cinema-info")
    @ResponseBody 
    public Object getCinemaInfo() {
        try {
            return singleCinemaService.getCinemaInfo();
        } catch (Exception e) {
            return Map.of("error", "Lỗi khi tải thông tin rạp: " + e.getMessage());
        }
    }
}
