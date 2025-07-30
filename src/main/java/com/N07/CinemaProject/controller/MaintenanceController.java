package com.N07.CinemaProject.controller;

import com.N07.CinemaProject.service.AuditoriumService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/admin/maintenance")
@PreAuthorize("hasRole('ADMIN')")
public class MaintenanceController {

    @Autowired
    private AuditoriumService auditoriumService;

    /**
     * Trang maintenance tools
     */
    @GetMapping("")
    public String maintenancePage() {
        return "maintenance";
    }

    /**
     * Endpoint để cập nhật mapping ghế theo yêu cầu mới
     * Có thể truy cập: /admin/maintenance/update-seats
     */
    @GetMapping("/update-seats")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateSeatMappings() {
        Map<String, Object> response = new HashMap<>();
        try {
            auditoriumService.updateExistingSeatMappings();
            response.put("success", true);
            response.put("message", "✅ Đã cập nhật mapping ghế thành công!\n\n" +
                    "📍 Mapping mới:\n" +
                    "🟡 A,B → Ghế thường (x1.0)\n" +
                    "🟠 C,D,E → Ghế VIP (x1.2)\n" +
                    "🔴 F → Ghế đôi (x2.0)\n\n" +
                    "⚡ Tất cả ghế hiện có đã được cập nhật!");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "❌ Lỗi khi cập nhật mapping ghế: " + e.getMessage());
        }
        return ResponseEntity.ok(response);
    }
}
