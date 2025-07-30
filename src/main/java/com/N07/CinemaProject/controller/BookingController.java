package com.N07.CinemaProject.controller;

import com.N07.CinemaProject.entity.Booking;
import com.N07.CinemaProject.entity.Screening;
import com.N07.CinemaProject.entity.User;
import com.N07.CinemaProject.dto.SeatDTO;
import com.N07.CinemaProject.service.BookingService;
import com.N07.CinemaProject.service.ScreeningService;
import com.N07.CinemaProject.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/booking")
public class BookingController {

    @Autowired
    private BookingService bookingService;
    @Autowired
    private ScreeningService screeningService;
    @Autowired
    private UserService userService;
    @GetMapping("/screening/{screeningId}")
    public String selectSeats(@PathVariable Long screeningId, Model model) {
        try {
            System.out.println("🎬 Loading seat selection for screening ID: " + screeningId);
            
            // Get current authenticated user
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            String username = authentication.getName();
            User currentUser = userService.findByUsername(username).orElse(null);
            
            if (currentUser == null) {
                System.err.println("❌ Current user not found: " + username);
                return "redirect:/auth/login";
            }
            
            Screening screening = screeningService.getScreeningById(screeningId).orElse(null);
            if (screening == null) {
                System.err.println("❌ Screening not found with ID: " + screeningId);
                return "redirect:/movies";
            }
            
            List<SeatDTO> availableSeats = bookingService.getSeatsWithStatus(screeningId);
            System.out.println("💺 Found " + availableSeats.size() + " seats for screening " + screeningId);
            
            if (availableSeats.isEmpty()) {
                System.err.println("⚠️ No seats found for screening " + screeningId + " in auditorium " + 
                    (screening.getAuditorium() != null ? screening.getAuditorium().getId() : "null"));
            }
            
            model.addAttribute("screening", screening);
            model.addAttribute("availableSeats", availableSeats);
            model.addAttribute("currentUser", currentUser);
            
            return "pages/seat-selection";
        } catch (Exception e) {
            System.err.println("❌ Error loading seat selection: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/movies";
        }
    }

    @PostMapping("/create")
    public String createBooking(@RequestParam Long screeningId,
                               @RequestParam String seatIds,
                               @RequestParam Long userId,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        try {
            // Parse seat IDs
            String[] seatIdArray = seatIds.split(",");
            List<Long> seatIdList = List.of(seatIdArray).stream()
                    .map(String::trim)
                    .map(Long::parseLong)
                    .toList();
            
            // Create booking with session info
            String sessionId = session.getId();
            Booking booking = bookingService.createBooking(userId, screeningId, seatIdList, sessionId);
            
            redirectAttributes.addFlashAttribute("success", "Đặt vé thành công! Vui lòng thanh toán để hoàn tất.");
            return "redirect:/payment/booking/" + booking.getId();
            
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
                    // Find current user by username and get their bookings
                    String username = auth.getName();
                    User currentUser = userService.findByUsername(username).orElse(null);
                    if (currentUser != null) {
                        bookings = bookingService.getBookingsByUser(currentUser.getId());
                    } else {
                        bookings = List.of();
                    }
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
