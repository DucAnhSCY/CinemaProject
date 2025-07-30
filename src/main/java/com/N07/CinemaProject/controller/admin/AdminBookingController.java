package com.N07.CinemaProject.controller.admin;

import com.N07.CinemaProject.entity.Booking;
import com.N07.CinemaProject.service.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/bookings")
@PreAuthorize("hasRole('ADMIN') or hasRole('THEATER_MANAGER')")
public class AdminBookingController {

    @Autowired
    private BookingService bookingService;

    @GetMapping
    public String listBookings(
            @RequestParam(defaultValue = "0") int page,
            Model model) {
        try {
            Pageable pageable = PageRequest.of(page, 20, Sort.by("bookingTime").descending());
            Page<Booking> bookings = bookingService.searchBookings(null, null, null, null, null, pageable);
            
            model.addAttribute("bookings", bookings);
            model.addAttribute("totalBookings", bookings.getTotalElements());
            
            // Calculate statistics
            Map<String, Long> stats = calculateBookingStats(bookings.getContent());
            model.addAttribute("reservedCount", stats.getOrDefault("RESERVED", 0L));
            model.addAttribute("confirmedCount", stats.getOrDefault("CONFIRMED", 0L));
            model.addAttribute("cancelledCount", stats.getOrDefault("CANCELLED", 0L));
            model.addAttribute("expiredCount", stats.getOrDefault("EXPIRED", 0L));
            
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi tải danh sách đặt vé: " + e.getMessage());
            model.addAttribute("bookings", Page.empty());
            model.addAttribute("totalBookings", 0);
            model.addAttribute("reservedCount", 0L);
            model.addAttribute("confirmedCount", 0L);
            model.addAttribute("cancelledCount", 0L);
            model.addAttribute("expiredCount", 0L);
        }
        return "admin/booking-management";
    }

    @GetMapping("/{id}")
    public String viewBookingDetails(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        try {
            Optional<Booking> bookingOpt = bookingService.getBookingById(id);
            if (bookingOpt.isPresent()) {
                Booking booking = bookingOpt.get();
                model.addAttribute("booking", booking);
                return "admin/booking-details";
            } else {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy thông tin đặt vé!");
                return "redirect:/admin/bookings";
            }
        } catch (Exception e) {
            System.err.println("❌ Error loading booking details: " + e.getMessage());
            e.printStackTrace(); // Debug log
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

    @GetMapping("/search")
    public String searchBookings(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String theater,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(defaultValue = "0") int page,
            Model model) {
        
        try {
            Pageable pageable = PageRequest.of(page, 20, Sort.by("bookingTime").descending());
            Page<Booking> bookings = bookingService.searchBookings(keyword, status, theater, startDate, endDate, pageable);
            
            model.addAttribute("bookings", bookings);
            model.addAttribute("keyword", keyword);
            model.addAttribute("status", status);
            model.addAttribute("theater", theater);
            model.addAttribute("startDate", startDate);
            model.addAttribute("endDate", endDate);
            
            // Statistics
            Map<String, Long> stats = calculateBookingStats(bookings.getContent());
            model.addAttribute("totalBookings", bookings.getTotalElements());
            model.addAttribute("reservedCount", stats.getOrDefault("RESERVED", 0L));
            model.addAttribute("confirmedCount", stats.getOrDefault("CONFIRMED", 0L));
            model.addAttribute("cancelledCount", stats.getOrDefault("CANCELLED", 0L));
            model.addAttribute("expiredCount", stats.getOrDefault("EXPIRED", 0L));
            
            return "admin/booking-management";
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi tìm kiếm: " + e.getMessage());
            return "admin/booking-management";
        }
    }

    @GetMapping("/export")
    public ResponseEntity<Resource> exportBookings(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String theater,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(defaultValue = "csv") String format) {
        
        try {
            List<Booking> bookings = bookingService.searchBookingsForExport(keyword, status, theater, startDate, endDate);
            
            if ("csv".equalsIgnoreCase(format)) {
                String csvContent = generateCsvContent(bookings);
                ByteArrayResource resource = new ByteArrayResource(csvContent.getBytes(StandardCharsets.UTF_8));
                
                return ResponseEntity.ok()
                        .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=bookings_export.csv")
                        .contentType(MediaType.parseMediaType("text/csv"))
                        .body(resource);
            } else {
                // Future: Excel export
                return ResponseEntity.badRequest().build();
            }
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @PostMapping("/{id}/send-notification")
    @ResponseBody
    public String sendBookingNotification(@PathVariable Long id, @RequestBody Map<String, String> request) {
        try {
            Optional<Booking> bookingOpt = bookingService.getBookingById(id);
            if (bookingOpt.isPresent()) {
                // Booking booking = bookingOpt.get();
                // String message = request.get("message");
                // String type = request.get("type");
                // notificationService.sendBookingNotification(booking, message, type);
                
                return "success";
            }
            return "error: Không tìm thấy đặt vé";
        } catch (Exception e) {
            return "error: " + e.getMessage();
        }
    }

    @GetMapping("/statistics")
    @ResponseBody
    public Map<String, Object> getBookingStatistics(
            @RequestParam(required = false) String period,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {
        
        try {
            Map<String, Object> stats = new HashMap<>();
            
            // Basic statistics
            List<Booking> allBookings = bookingService.getAllBookings();
            Map<String, Long> statusStats = calculateBookingStats(allBookings);
            stats.put("statusStats", statusStats);
            
            // Revenue statistics
            BigDecimal totalRevenue = allBookings.stream()
                    .filter(b -> b.getBookingStatus() == Booking.BookingStatus.CONFIRMED)
                    .map(Booking::getTotalAmount)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            stats.put("totalRevenue", totalRevenue);
            
            // Daily statistics for charts
            Map<String, Long> dailyBookings = allBookings.stream()
                    .collect(Collectors.groupingBy(
                            b -> b.getBookingTime().toLocalDate().toString(),
                            Collectors.counting()
                    ));
            stats.put("dailyBookings", dailyBookings);
            
            return stats;
        } catch (Exception e) {
            Map<String, Object> errorStats = new HashMap<>();
            errorStats.put("error", e.getMessage());
            return errorStats;
        }
    }

    private Map<String, Long> calculateBookingStats(List<Booking> bookings) {
        return bookings.stream()
                .collect(Collectors.groupingBy(
                        b -> b.getBookingStatus().name(),
                        Collectors.counting()
                ));
    }

    private String generateCsvContent(List<Booking> bookings) {
        StringBuilder csv = new StringBuilder();
        
        // CSV Header
        csv.append("ID,Khách hàng,Email,Phim,Rạp,Phòng,Ngày chiếu,Giờ chiếu,Số ghế,Tổng tiền,Trạng thái,Ngày đặt\n");
        
        // CSV Data
        for (Booking booking : bookings) {
            csv.append(booking.getId()).append(",");
            csv.append(booking.getUser() != null ? booking.getUser().getFullName() : "Khách vãng lai").append(",");
            csv.append(booking.getUser() != null ? booking.getUser().getEmail() : "").append(",");
            csv.append(booking.getScreening().getMovie().getTitle()).append(",");
            csv.append(booking.getScreening().getAuditorium().getTheater().getName()).append(",");
            csv.append(booking.getScreening().getAuditorium().getName()).append(",");
            csv.append(booking.getScreening().getStartTime().toLocalDate()).append(",");
            csv.append(booking.getScreening().getStartTime().toLocalTime()).append(",");
            csv.append(booking.getBookedSeats().size()).append(",");
            csv.append(booking.getTotalAmount()).append(",");
            csv.append(getStatusInVietnamese(booking.getBookingStatus())).append(",");
            csv.append(booking.getBookingTime().toLocalDate()).append("\n");
        }
        
        return csv.toString();
    }

    private String getStatusInVietnamese(Booking.BookingStatus status) {
        switch (status) {
            case RESERVED: return "Chờ xác nhận";
            case CONFIRMED: return "Đã xác nhận";
            case CANCELLED: return "Đã hủy";
            case EXPIRED: return "Hết hạn";
            default: return "Không xác định";
        }
    }
}
