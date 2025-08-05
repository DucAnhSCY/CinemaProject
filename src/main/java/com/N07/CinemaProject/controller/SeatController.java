package com.N07.CinemaProject.controller;

import com.N07.CinemaProject.service.SeatHoldService;
import com.N07.CinemaProject.service.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/seats")
public class SeatController {
    
    @Autowired
    private SeatHoldService seatHoldService;
    
    @Autowired
    private BookingService bookingService;
    
    @PostMapping("/hold")
    public ResponseEntity<Map<String, Object>> holdSeats(
            @RequestParam Long screeningId,
            @RequestParam String seatIds,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Parse seat IDs
            List<Long> seatIdList = Arrays.stream(seatIds.split(","))
                .map(String::trim)
                .map(Long::parseLong)
                .toList();
            
            String sessionId = session.getId();
            
            // Add retry logic for deadlock handling
            boolean success = false;
            int maxRetries = 3;
            int retryCount = 0;
            
            while (!success && retryCount < maxRetries) {
                try {
                    success = seatHoldService.holdSeats(seatIdList, screeningId, sessionId);
                    if (!success && retryCount < maxRetries - 1) {
                        // Wait a bit before retry to avoid immediate collision
                        Thread.sleep(50 + (retryCount * 50)); // Progressive backoff
                        retryCount++;
                    } else {
                        break;
                    }
                } catch (Exception e) {
                    retryCount++;
                    if (retryCount >= maxRetries) {
                        throw e; // Re-throw if all retries failed
                    }
                    Thread.sleep(50 + (retryCount * 50));
                }
            }
            
            if (success) {
                response.put("success", true);
                response.put("message", "Ghế đã được giữ chỗ trong 10 phút");
                response.put("expiresIn", 600); // 10 minutes in seconds
            } else {
                response.put("success", false);
                response.put("message", "Không thể giữ chỗ. Một số ghế đã được chọn bởi người khác");
            }
            
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            response.put("success", false);
            response.put("message", "Quá trình giữ chỗ bị gián đoạn");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }
    
    @PostMapping("/release")
    public ResponseEntity<Map<String, Object>> releaseHolds(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            String sessionId = session.getId();
            seatHoldService.releaseHoldsByUserSession(sessionId);
            
            response.put("success", true);
            response.put("message", "Đã hủy giữ chỗ");
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/status/{screeningId}")
    public ResponseEntity<Object> getSeatsStatus(@PathVariable Long screeningId) {
        try {
            return ResponseEntity.ok(bookingService.getSeatsWithStatus(screeningId));
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }
}
