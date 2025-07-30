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
            
            System.out.println("🎭 Demo Seat Selection - Found " + availableSeats.size() + " seats for screening " + demoScreeningId);
            
            // Tạo mock screening data cho demo 
            model.addAttribute("screeningId", demoScreeningId);
            model.addAttribute("availableSeats", availableSeats);
            
            // Tạo mock screening object
            MockScreening mockScreening = new MockScreening();
            mockScreening.id = demoScreeningId;
            mockScreening.ticketPrice = 120000.0;
            model.addAttribute("screening", mockScreening);
            
            return "pages/seat-selection";
        } catch (Exception e) {
            System.err.println("❌ Error in demo seat selection: " + e.getMessage());
            e.printStackTrace();
            // Fallback nếu không có dữ liệu
            model.addAttribute("error", "Không thể tải dữ liệu demo: " + e.getMessage());
            return "redirect:/movies";
        }
    }
    
    @GetMapping("/seat-data")
    public String showSeatData(Model model) {
        try {
            Long demoScreeningId = 1L;
            List<SeatDTO> seats = bookingService.getSeatsWithStatus(demoScreeningId);
            
            System.out.println("🔍 Debug - Found " + seats.size() + " seats for screening " + demoScreeningId);
            for (SeatDTO seat : seats) {
                System.out.println("  - Seat " + seat.getRowNumber() + seat.getSeatPosition() + 
                    " (ID: " + seat.getId() + ", Type: " + seat.getSeatType() + ", Booked: " + seat.isBooked() + ")");
            }
            
            model.addAttribute("screeningId", demoScreeningId);
            model.addAttribute("availableSeats", seats);
            
            return "debug/seat-debug";
        } catch (Exception e) {
            System.err.println("❌ Error getting seat data: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", e.getMessage());
            return "debug/seat-debug";
        }
    }
    
    // Mock class cho demo
    public static class MockScreening {
        public Long id;
        public Double ticketPrice;
        
        public Long getId() { return id; }
        public Double getTicketPrice() { return ticketPrice; }
    }
}
