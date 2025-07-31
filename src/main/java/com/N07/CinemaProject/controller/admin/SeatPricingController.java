package com.N07.CinemaProject.controller.admin;

import com.N07.CinemaProject.service.AuditoriumService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/seat-pricing")
public class SeatPricingController {

    @Autowired
    private AuditoriumService auditoriumService;

    /**
     * Cập nhật hệ số giá cho tất cả ghế hiện có
     * A,B: x1.0 (ghế thường)
     * C,D,E: x1.2 (ghế VIP) 
     * F: x1.7 (ghế couple)
     */
    @PostMapping("/update-price-multipliers")
    public ResponseEntity<Map<String, Object>> updateSeatPriceMultipliers() {
        Map<String, Object> response = new HashMap<>();
        
        try {
            auditoriumService.updateExistingSeatMappings();
            
            response.put("success", true);
            response.put("message", "Đã cập nhật hệ số giá thành công!");
            response.put("priceMultipliers", Map.of(
                "rowA_B", "x1.0 (Ghế thường)",
                "rowC_D_E", "x1.2 (Ghế VIP)",
                "rowF", "x1.7 (Ghế Couple)"
            ));
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi khi cập nhật hệ số giá: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    /**
     * Xem thông tin hệ số giá hiện tại
     */
    @GetMapping("/price-multipliers-info")
    public ResponseEntity<Map<String, Object>> getPriceMultipliersInfo() {
        Map<String, Object> response = new HashMap<>();
        
        response.put("priceStructure", Map.of(
            "standard", Map.of(
                "rows", "A, B",
                "multiplier", "x1.0",
                "description", "Ghế thường"
            ),
            "vip", Map.of(
                "rows", "C, D, E", 
                "multiplier", "x1.2",
                "description", "Ghế VIP"
            ),
            "couple", Map.of(
                "rows", "F",
                "multiplier", "x1.7", 
                "description", "Ghế Couple"
            )
        ));
        
        return ResponseEntity.ok(response);
    }
}
