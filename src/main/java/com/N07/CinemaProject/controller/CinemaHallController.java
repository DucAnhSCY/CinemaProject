package com.N07.CinemaProject.controller;

import com.N07.CinemaProject.entity.Auditorium;
import com.N07.CinemaProject.entity.Seat;
import com.N07.CinemaProject.entity.Theater;
import com.N07.CinemaProject.service.AuditoriumService;
import com.N07.CinemaProject.service.TheaterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/cinema-halls")
@PreAuthorize("hasRole('ADMIN')")
public class CinemaHallController {

    @Autowired
    private AuditoriumService auditoriumService;
    
    @Autowired
    private TheaterService theaterService;

    @GetMapping("")
    public String listCinemaHalls(Model model) {
        try {
            // Load all theaters with their auditoriums
            List<Theater> theaters = theaterService.getAllTheaters();
            
            // Group auditoriums by theater for easier display
            Map<Theater, List<Auditorium>> theaterAuditoriumMap = new HashMap<>();
            for (Theater theater : theaters) {
                List<Auditorium> auditoriums = auditoriumService.getAuditoriumsByTheaterId(theater.getId());
                theaterAuditoriumMap.put(theater, auditoriums);
            }
            
            model.addAttribute("pageTitle", "Quản Lý Phòng Chiếu");
            model.addAttribute("theaterAuditoriumMap", theaterAuditoriumMap);
            model.addAttribute("theaters", theaters);
            
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Có lỗi khi tải danh sách phòng chiếu: " + e.getMessage());
        }
        
        return "admin/cinema-hall-management";
    }

    @GetMapping("/theater/{theaterId}")
    public String getCinemaHallsByTheater(@PathVariable Long theaterId, Model model) {
        try {
            Theater theater = theaterService.getTheaterById(theaterId)
                    .orElseThrow(() -> new RuntimeException("Theater not found"));
            
            List<Auditorium> auditoriums = auditoriumService.getAuditoriumsByTheaterId(theaterId);
            
            model.addAttribute("pageTitle", "Phòng Chiếu - " + theater.getName());
            model.addAttribute("theater", theater);
            model.addAttribute("auditoriums", auditoriums);
            model.addAttribute("theaterId", theaterId);
            
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Có lỗi khi tải danh sách phòng chiếu: " + e.getMessage());
        }
        
        return "admin/cinema-hall-management";
    }

    @GetMapping("/new")
    public String showCreateForm(@RequestParam(required = false) Long theaterId, Model model) {
        try {
            model.addAttribute("pageTitle", "Thêm Phòng Chiếu Mới");
            model.addAttribute("theaterId", theaterId);
            
            // Load available theaters for dropdown
            List<Theater> theaters = theaterService.getAllTheaters();
            model.addAttribute("theaters", theaters);
            
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Có lỗi khi tải form: " + e.getMessage());
        }
        
        return "admin/cinema-hall-form";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model) {
        try {
            Auditorium auditorium = auditoriumService.getAuditoriumById(id)
                    .orElseThrow(() -> new RuntimeException("Auditorium not found"));
            
            // Load available theaters for dropdown
            List<Theater> theaters = theaterService.getAllTheaters();
            
            model.addAttribute("pageTitle", "Chỉnh Sửa Phòng Chiếu");
            model.addAttribute("auditorium", auditorium);
            model.addAttribute("theaters", theaters);
            model.addAttribute("cinemaHallId", id);
            
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Có lỗi khi tải thông tin phòng chiếu: " + e.getMessage());
            return "redirect:/admin/cinema-halls";
        }
        
        return "admin/cinema-hall-form";
    }

    @PostMapping("/save")
    public String saveCinemaHall(@RequestParam String name,
                                @RequestParam Long theaterId,
                                @RequestParam int totalSeats,
                                @RequestParam int rows,
                                @RequestParam int seatsPerRow,
                                @RequestParam(required = false) Long id,
                                @RequestParam(required = false) String addAnother,
                                RedirectAttributes redirectAttributes) {
        try {
            // Validate input
            if (name == null || name.trim().isEmpty()) {
                throw new RuntimeException("Tên phòng chiếu không được để trống");
            }
            
            if (rows <= 0 || seatsPerRow <= 0) {
                throw new RuntimeException("Số hàng và ghế per hàng phải lớn hơn 0");
            }
            
            if (totalSeats != rows * seatsPerRow) {
                totalSeats = rows * seatsPerRow; // Auto calculate
            }
            
            if (id != null) {
                // Update existing auditorium
                auditoriumService.updateAuditorium(id, name.trim(), theaterId, totalSeats);
                redirectAttributes.addFlashAttribute("successMessage", "Cập nhật phòng chiếu thành công!");
            } else {
                // Create new auditorium
                auditoriumService.createAuditorium(name.trim(), theaterId, totalSeats, rows, seatsPerRow);
                redirectAttributes.addFlashAttribute("successMessage", "Thêm phòng chiếu thành công!");
                
                // Check if user wants to add another
                if ("true".equals(addAnother)) {
                    return "redirect:/admin/cinema-halls/new?theaterId=" + theaterId;
                }
            }
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            
            // Return to form if there's an error
            if (id != null) {
                return "redirect:/admin/cinema-halls/edit/" + id;
            } else {
                return "redirect:/admin/cinema-halls/new" + (theaterId != null ? "?theaterId=" + theaterId : "");
            }
        }
        
        return "redirect:/admin/cinema-halls";
    }

    @PostMapping("/delete/{id}")
    public String deleteCinemaHall(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            auditoriumService.deleteAuditorium(id);
            redirectAttributes.addFlashAttribute("successMessage", "Xóa phòng chiếu thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không thể xóa phòng chiếu: " + e.getMessage());
        }
        return "redirect:/admin/cinema-halls";
    }

    @GetMapping("/api/{id}/seats")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getCinemaHallSeats(@PathVariable Long id) {
        try {
            List<Seat> seats = auditoriumService.getSeatsByAuditoriumId(id);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("seats", seats.stream().map(seat -> {
                Map<String, Object> seatData = new HashMap<>();
                seatData.put("id", seat.getId());
                seatData.put("row", seat.getRowNumber());
                seatData.put("position", seat.getSeatPosition());
                seatData.put("type", seat.getSeatType().toString());
                return seatData;
            }).collect(Collectors.toList()));
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }

    @PostMapping("/api/{id}/seats")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateCinemaHallSeats(@PathVariable Long id, @RequestBody String seatLayout) {
        try {
            auditoriumService.updateSeatLayout(id, seatLayout);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Cập nhật layout ghế thành công");
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }
    
    @GetMapping("/api/check-name")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> checkAuditoriumName(
            @RequestParam String name,
            @RequestParam Long theaterId,
            @RequestParam(required = false) Long id) {
        
        Map<String, Object> response = new HashMap<>();
        
        boolean exists;
        if (id != null) {
            exists = auditoriumService.existsByNameAndTheaterIdAndIdNot(name, theaterId, id);
        } else {
            exists = auditoriumService.existsByNameAndTheaterId(name, theaterId);
        }
        
        response.put("exists", exists);
        if (exists) {
            response.put("message", "Tên phòng chiếu đã tồn tại trong rạp này");
        }
        
        return ResponseEntity.ok(response);
    }
    
    /**
     * Endpoint để cập nhật mapping ghế theo yêu cầu mới:
     * A,B → STANDARD (x1.0)
     * C,D,E → VIP (x1.2)  
     * F → COUPLE (x2.0)
     */
    @PostMapping("/update-seat-mappings")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateSeatMappings() {
        Map<String, Object> response = new HashMap<>();
        try {
            auditoriumService.updateExistingSeatMappings();
            response.put("success", true);
            response.put("message", "Đã cập nhật mapping ghế thành công!\n" +
                    "A,B → Ghế thường (x1.0)\n" +
                    "C,D,E → Ghế VIP (x1.2)\n" +
                    "F → Ghế đôi (x2.0)");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi khi cập nhật mapping ghế: " + e.getMessage());
        }
        return ResponseEntity.ok(response);
    }
}
