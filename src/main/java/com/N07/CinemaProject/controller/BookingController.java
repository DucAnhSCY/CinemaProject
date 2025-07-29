package com.N07.CinemaProject.controller;

import com.N07.CinemaProject.entity.Booking;
import com.N07.CinemaProject.entity.Screening;
import com.N07.CinemaProject.dto.SeatDTO;
import com.N07.CinemaProject.service.BookingService;
import com.N07.CinemaProject.service.ScreeningService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/booking")
public class BookingController {

    @Autowired
    private BookingService bookingService;
    @Autowired
    private ScreeningService screeningService;
    @GetMapping("/screening/{screeningId}")
    public String selectSeats(@PathVariable Long screeningId, Model model) {
        try {
            Screening screening = screeningService.getScreeningById(screeningId).orElse(null);
            if (screening == null) {
                return "redirect:/movies";
            }
            
            List<SeatDTO> availableSeats = bookingService.getSeatsWithStatus(screeningId);
            
            model.addAttribute("screening", screening);
            model.addAttribute("availableSeats", availableSeats);
            
            return "pages/seat-selection";
        } catch (Exception e) {
            return "redirect:/movies";
        }
    }

    @PostMapping("/create")
    public String createBooking(@RequestParam Long screeningId,
                               @RequestParam String seatIds,
                               @RequestParam Long userId,
                               RedirectAttributes redirectAttributes) {
        try {
            // Parse seat IDs
            String[] seatIdArray = seatIds.split(",");
            List<Long> seatIdList = List.of(seatIdArray).stream()
                    .map(String::trim)
                    .map(Long::parseLong)
                    .toList();
            
            // Create booking
            Booking booking = bookingService.createBooking(userId, screeningId, seatIdList);
            
            redirectAttributes.addFlashAttribute("success", "Đặt vé thành công!");
            return "redirect:/booking/confirmation/" + booking.getId();
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Đặt vé thất bại: " + e.getMessage());
            return "redirect:/booking/screening/" + screeningId;
        }
    }

    @GetMapping("/confirmation/{bookingId}")
    public String bookingConfirmation(@PathVariable Long bookingId, Model model) {
        try {
            Booking booking = bookingService.getBookingById(bookingId).orElse(null);
            if (booking == null) {
                return "redirect:/movies";
            }
            
            model.addAttribute("booking", booking);
            return "pages/booking-confirmation";
        } catch (Exception e) {
            return "redirect:/movies";
        }
    }

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

    @GetMapping("/test")
    @ResponseBody
    public String testBooking() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getPrincipal())) {
            return "User is authenticated: " + auth.getName() + " - Authorities: " + auth.getAuthorities();
        } else {
            return "User is NOT authenticated. Principal: " + (auth != null ? auth.getPrincipal() : "null");
        }
    }
}
