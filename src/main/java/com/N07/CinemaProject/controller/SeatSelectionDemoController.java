package com.N07.CinemaProject.controller;

import com.N07.CinemaProject.dto.SeatDTO;
import com.N07.CinemaProject.service.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

/**
 * Demo Controller để test giao diện chọn ghế với dữ liệu thực
 */
@Controller
@RequestMapping("/demo")
public class SeatSelectionDemoController {

    @Autowired
    private BookingService bookingService;

    @GetMapping("/seat-selection")
    public String demoSeatSelection(Model model) {
        try {
            // Sử dụng screening ID = 1 để demo (có thể thay đổi)
            Long demoScreeningId = 1L;
            
            // Lấy dữ liệu ghế thực từ database
            List<SeatDTO> availableSeats = bookingService.getSeatsWithStatus(demoScreeningId);
            
            // Tạo mock screening data cho demo 
            model.addAttribute("screeningId", demoScreeningId);
            model.addAttribute("availableSeats", availableSeats);
            
            return "pages/seat-selection";
        } catch (Exception e) {
            // Fallback nếu không có dữ liệu
            model.addAttribute("error", "Không thể tải dữ liệu demo: " + e.getMessage());
            return "pages/error";
        }
    }
    
    
    @GetMapping("/seat-data")
    public String showSeatData(Model model) {
        try {
            Long demoScreeningId = 1L;
            List<SeatDTO> seats = bookingService.getSeatsWithStatus(demoScreeningId);
            
            model.addAttribute("seats", seats);
            model.addAttribute("totalSeats", seats.size());
            
            // Thống kê theo loại ghế
            long vipCount = seats.stream().filter(s -> "VIP".equals(s.getSeatType())).count();
            long standardCount = seats.stream().filter(s -> "STANDARD".equals(s.getSeatType())).count();
            long coupleCount = seats.stream().filter(s -> "COUPLE".equals(s.getSeatType())).count();
            long bookedCount = seats.stream().filter(SeatDTO::isBooked).count();
            
            model.addAttribute("vipCount", vipCount);
            model.addAttribute("standardCount", standardCount);
            model.addAttribute("coupleCount", coupleCount);
            model.addAttribute("bookedCount", bookedCount);
            model.addAttribute("availableCount", seats.size() - bookedCount);
            
            return "demo/seat-data";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "pages/error";
        }
    }
}
