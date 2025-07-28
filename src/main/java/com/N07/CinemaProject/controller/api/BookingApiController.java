package com.N07.CinemaProject.controller.api;

import com.N07.CinemaProject.dto.SeatDTO;
import com.N07.CinemaProject.entity.Booking;
import com.N07.CinemaProject.entity.Screening;
import com.N07.CinemaProject.entity.User;
import com.N07.CinemaProject.service.BookingService;
import com.N07.CinemaProject.service.ScreeningService;
import com.N07.CinemaProject.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Optional;

@RestController
@RequestMapping("/api/booking")
@CrossOrigin(origins = "*")
public class BookingApiController {

    @Autowired
    private BookingService bookingService;

    @Autowired
    private ScreeningService screeningService;
    
    @Autowired
    private UserService userService;
    @GetMapping("/screening/{screeningId}/seats")
    public ResponseEntity<List<SeatDTO>> getAvailableSeats(@PathVariable Long screeningId) {
        try {
            List<SeatDTO> seats = bookingService.getSeatsWithStatus(screeningId);
            return ResponseEntity.ok(seats);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @PostMapping("/create")
    public ResponseEntity<Map<String, Object>> createBooking(@RequestBody Map<String, Object> bookingData) {
        try {
            Map<String, Object> response = new HashMap<>();
            
            // Get current authenticated user
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication == null || !authentication.isAuthenticated() || 
                "anonymousUser".equals(authentication.getName())) {
                response.put("success", false);
                response.put("message", "Bạn cần đăng nhập để đặt vé");
                return ResponseEntity.status(401).body(response);
            }
            
            // Find user by username/email
            String username = authentication.getName();
            Optional<User> userOpt = userService.findByUsername(username);
            if (userOpt.isEmpty()) {
                userOpt = userService.findByEmail(username);
            }
            
            if (userOpt.isEmpty()) {
                response.put("success", false);
                response.put("message", "Không tìm thấy thông tin người dùng");
                return ResponseEntity.status(401).body(response);
            }
            
            User user = userOpt.get();
            
            // Extract booking data
            Long screeningId = Long.valueOf(bookingData.get("screeningId").toString());
            @SuppressWarnings("unchecked")
            List<Long> seatIds = (List<Long>) bookingData.get("seatIds");
            
            // Validate screening exists
            Optional<Screening> screeningOpt = screeningService.getScreeningById(screeningId);
            if (screeningOpt.isEmpty()) {
                response.put("success", false);
                response.put("message", "Suất chiếu không tồn tại");
                return ResponseEntity.badRequest().body(response);
            }
            
            // Create booking
            Booking booking = bookingService.createBooking(user.getId(), screeningId, seatIds);
            
            response.put("success", true);
            response.put("bookingId", booking.getId());
            response.put("booking", booking);
            response.put("message", "Đặt vé thành công!");
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Đặt vé thất bại: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @GetMapping("/{bookingId}")
    public ResponseEntity<Booking> getBooking(@PathVariable Long bookingId) {
        try {
            Optional<Booking> bookingOpt = bookingService.getBookingById(bookingId);
            return bookingOpt.map(ResponseEntity::ok)
                           .orElse(ResponseEntity.notFound().build());
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Booking>> getUserBookings(@PathVariable Long userId) {
        try {
            List<Booking> bookings = bookingService.getBookingsByUserId(userId);
            return ResponseEntity.ok(bookings);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    @GetMapping("/my-bookings")
    public ResponseEntity<Map<String, Object>> getCurrentUserBookings() {
        try {
            // Get current authenticated user
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication == null || !authentication.isAuthenticated() || 
                "anonymousUser".equals(authentication.getName())) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "Bạn cần đăng nhập để xem lịch sử đặt vé");
                return ResponseEntity.status(401).body(response);
            }
            
            // Find user by username/email
            String username = authentication.getName();
            Optional<User> userOpt = userService.findByUsername(username);
            if (userOpt.isEmpty()) {
                userOpt = userService.findByEmail(username);
            }
            
            if (userOpt.isEmpty()) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "Không tìm thấy thông tin người dùng");
                return ResponseEntity.status(401).body(response);
            }
            
            User user = userOpt.get();
            List<Booking> bookings = bookingService.getBookingsByUserId(user.getId());
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("bookings", bookings);
            response.put("user", user);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Lỗi khi tải lịch sử đặt vé: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PostMapping("/payment")
    public ResponseEntity<Map<String, Object>> processPayment(@RequestBody Map<String, Object> paymentData) {
        try {
            Map<String, Object> response = new HashMap<>();
            
            // Get current authenticated user for security
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication == null || !authentication.isAuthenticated() || 
                "anonymousUser".equals(authentication.getName())) {
                response.put("success", false);
                response.put("message", "Bạn cần đăng nhập để thanh toán");
                return ResponseEntity.status(401).body(response);
            }
            
            // Extract and validate payment data
            String cardNumber = paymentData.get("cardNumber").toString();
            String expiryDate = paymentData.get("expiryDate").toString();
            String cvv = paymentData.get("cvv").toString();
            Double amount = Double.valueOf(paymentData.get("amount").toString());
            
            // Simple validation
            if (cardNumber.length() < 16 || cvv.length() < 3) {
                response.put("success", false);
                response.put("message", "Thông tin thẻ không hợp lệ");
                return ResponseEntity.badRequest().body(response);
            }
            
            // Validate expiry date format (MM/YY)
            if (!expiryDate.matches("\\d{2}/\\d{2}")) {
                response.put("success", false);
                response.put("message", "Ngày hết hạn không đúng định dạng MM/YY");
                return ResponseEntity.badRequest().body(response);
            }
            
            // Validate amount
            if (amount <= 0) {
                response.put("success", false);
                response.put("message", "Số tiền thanh toán không hợp lệ");
                return ResponseEntity.badRequest().body(response);
            }
            
            // Simulate successful payment
            response.put("success", true);
            response.put("transactionId", "TXN" + System.currentTimeMillis());
            response.put("amount", amount);
            response.put("paymentTime", java.time.LocalDateTime.now().toString());
            response.put("message", "Thanh toán thành công!");
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Thanh toán thất bại: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}
