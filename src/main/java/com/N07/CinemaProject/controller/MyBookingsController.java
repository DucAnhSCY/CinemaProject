package com.N07.CinemaProject.controller;

import com.N07.CinemaProject.entity.Booking;
import com.N07.CinemaProject.service.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class MyBookingsController {
    
    @Autowired
    private BookingService bookingService;
    
    @GetMapping("/my-bookings")
    public String myBookings(@RequestParam(required = false) Long userId, Model model) {
        try {
            List<Booking> bookings;
            if (userId != null) {
                bookings = bookingService.getBookingsByUser(userId);
            } else {
                // Get current authenticated user's bookings
                Authentication auth = SecurityContextHolder.getContext().getAuthentication();
                if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getName())) {
                    // Try to find user and get their bookings
                    bookings = bookingService.getBookingsByUser(1L); // Fallback for demo
                } else {
                    bookings = List.of();
                }
            }
            model.addAttribute("bookings", bookings);
            return "pages/my-bookings";
        } catch (Exception e) {
            model.addAttribute("bookings", List.of());
            return "pages/my-bookings";
        }
    }
}
