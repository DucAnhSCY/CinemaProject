package com.N07.CinemaProject.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import com.N07.CinemaProject.repository.UserRepository;
import com.N07.CinemaProject.repository.TheaterRepository;
import com.N07.CinemaProject.repository.BookingRepository;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/admin")
@PreAuthorize("hasRole('ADMIN') or hasRole('THEATER_MANAGER')")
public class AdminController {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private TheaterRepository theaterRepository;
    
    @Autowired
    private BookingRepository bookingRepository;

    @GetMapping("")
    public String adminDashboard(Model model) {
        // Main admin dashboard
        model.addAttribute("pageTitle", "Admin Dashboard");
        return "admin/dashboard";
    }

    @GetMapping("/system")
    @PreAuthorize("hasRole('ADMIN')")
    public String systemAdmin(Model model) {
        // Add any necessary model attributes for system admin dashboard
        model.addAttribute("pageTitle", "Quản Trị Hệ Thống");
        return "system-admin";
    }

    @GetMapping("/theater")
    public String theaterAdmin(Model model) {
        // Add any necessary model attributes for theater admin dashboard
        model.addAttribute("pageTitle", "Quản Lý Rạp Chiếu");
        return "theater-admin";
    }

    @GetMapping("/reports")
    public String reportsPage(Model model) {
        try {
            // Get basic statistics for reports
            long totalUsers = userRepository.count();
            long totalTheaters = theaterRepository.count();
            long totalBookings = bookingRepository.count();
            
            model.addAttribute("totalUsers", totalUsers);
            model.addAttribute("totalTheaters", totalTheaters);
            model.addAttribute("totalBookings", totalBookings);
            model.addAttribute("pageTitle", "Báo Cáo Thống Kê");
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi tải báo cáo: " + e.getMessage());
        }
        return "admin/reports";
    }
    
    // API endpoints for system admin
    @GetMapping("/api/dashboard-stats")
    @ResponseBody
    public Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalUsers", userRepository.count());
        stats.put("totalTheaters", theaterRepository.count());
        stats.put("totalBookings", bookingRepository.count());
        // Add more statistics as needed
        return stats;
    }
    
    @GetMapping("/api/users")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public Object getUsers() {
        return userRepository.findAll();
    }
    
    @GetMapping("/api/theaters")
    @ResponseBody 
    public Object getTheaters() {
        return theaterRepository.findAll();
    }
}
