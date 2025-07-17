package com.N07.CinemaProject.controller.admin;

import com.N07.CinemaProject.entity.Booking;
import com.N07.CinemaProject.service.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin/bookings")
@PreAuthorize("hasRole('ADMIN') or hasRole('THEATER_MANAGER')")
public class AdminBookingController {

    @Autowired
    private BookingService bookingService;

    @GetMapping
    public String listBookings(Model model) {
        try {
            List<Booking> bookings = bookingService.getAllBookings();
            model.addAttribute("bookings", bookings);
            model.addAttribute("totalBookings", bookings.size());
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi tải danh sách đặt vé: " + e.getMessage());
            model.addAttribute("bookings", List.of());
        }
        return "admin/booking-management";
    }

    @GetMapping("/{id}")
    public String viewBookingDetails(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        try {
            Optional<Booking> bookingOpt = bookingService.getBookingById(id);
            if (bookingOpt.isPresent()) {
                model.addAttribute("booking", bookingOpt.get());
                return "admin/booking-details";
            } else {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy thông tin đặt vé!");
                return "redirect:/admin/bookings";
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi khi tải thông tin đặt vé: " + e.getMessage());
            return "redirect:/admin/bookings";
        }
    }

    @PostMapping("/{id}/cancel")
    @ResponseBody
    public String cancelBooking(@PathVariable Long id) {
        try {
            Optional<Booking> bookingOpt = bookingService.getBookingById(id);
            if (bookingOpt.isPresent()) {
                Booking booking = bookingOpt.get();
                if (booking.getBookingStatus() == Booking.BookingStatus.CONFIRMED) {
                    booking.setBookingStatus(Booking.BookingStatus.CANCELLED);
                    bookingService.save(booking);
                    return "success";
                } else {
                    return "error: Chỉ có thể hủy đặt vé đã xác nhận";
                }
            }
            return "error: Không tìm thấy đặt vé";
        } catch (Exception e) {
            return "error: " + e.getMessage();
        }
    }

    @PostMapping("/{id}/confirm")
    @ResponseBody
    public String confirmBooking(@PathVariable Long id) {
        try {
            Optional<Booking> bookingOpt = bookingService.getBookingById(id);
            if (bookingOpt.isPresent()) {
                Booking booking = bookingOpt.get();
                if (booking.getBookingStatus() == Booking.BookingStatus.RESERVED) {
                    booking.setBookingStatus(Booking.BookingStatus.CONFIRMED);
                    bookingService.save(booking);
                    return "success";
                } else {
                    return "error: Chỉ có thể xác nhận đặt vé đang chờ";
                }
            }
            return "error: Không tìm thấy đặt vé";
        } catch (Exception e) {
            return "error: " + e.getMessage();
        }
    }

    @GetMapping("/api")
    @ResponseBody
    public List<Booking> getBookingsApi() {
        try {
            return bookingService.getAllBookings();
        } catch (Exception e) {
            return List.of();
        }
    }
}
