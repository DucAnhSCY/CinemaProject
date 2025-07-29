package com.N07.CinemaProject.controller.admin;

import com.N07.CinemaProject.entity.Theater;
import com.N07.CinemaProject.entity.Auditorium;
import com.N07.CinemaProject.service.SingleCinemaService;
import com.N07.CinemaProject.service.AuditoriumService;
import com.N07.CinemaProject.repository.TheaterRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/admin/theaters")
@PreAuthorize("hasRole('ADMIN') or hasRole('THEATER_MANAGER')")
public class AdminTheaterController {

    @Autowired
    private SingleCinemaService singleCinemaService;
    
    @Autowired
    private AuditoriumService auditoriumService;
    
    @Autowired
    private TheaterRepository theaterRepository;

    @GetMapping
    public String cinemaManagement(Model model) {
        try {
            SingleCinemaService.CinemaInfo cinemaInfo = singleCinemaService.getCinemaInfo();
            model.addAttribute("cinemaInfo", cinemaInfo);
            
            // Thống kê chi tiết về từng phòng chiếu
            List<Auditorium> auditoriums = cinemaInfo.getAuditoriums();
            model.addAttribute("auditoriums", auditoriums);
            
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi tải thông tin rạp: " + e.getMessage());
        }
        
        return "admin/cinema-management";
    }

    @GetMapping("/edit")
    public String editCinemaForm(Model model) {
        try {
            Theater cinema = singleCinemaService.getCinema();
            model.addAttribute("theater", cinema);
            return "admin/cinema-edit-form";
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi tải thông tin rạp: " + e.getMessage());
            return "redirect:/admin/theaters";
        }
    }

    @PostMapping("/edit")
    public String editCinema(@ModelAttribute Theater theater, RedirectAttributes redirectAttributes) {
        try {
            Theater existingCinema = singleCinemaService.getCinema();
            theater.setId(existingCinema.getId());
            theaterRepository.save(theater);
            redirectAttributes.addFlashAttribute("success", "Đã cập nhật thông tin rạp thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi khi cập nhật thông tin rạp: " + e.getMessage());
        }
        return "redirect:/admin/theaters";
    }

    @GetMapping("/auditoriums/{auditoriumId}")
    public String auditoriumDetail(@PathVariable Long auditoriumId, Model model) {
        try {
            Optional<Auditorium> auditoriumOpt = auditoriumService.getAuditoriumById(auditoriumId);
            if (!auditoriumOpt.isPresent()) {
                model.addAttribute("error", "Không tìm thấy phòng chiếu");
                return "redirect:/admin/theaters";
            }
            
            Auditorium auditorium = auditoriumOpt.get();
            
            // Kiểm tra phòng chiếu có thuộc rạp không
            if (!singleCinemaService.isAuditoriumBelongsToOurCinema(auditoriumId)) {
                model.addAttribute("error", "Phòng chiếu không thuộc về rạp này");
                return "redirect:/admin/theaters";
            }
            
            model.addAttribute("auditorium", auditorium);
            model.addAttribute("seats", auditorium.getSeats());
            
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi tải thông tin phòng chiếu: " + e.getMessage());
            return "redirect:/admin/theaters";
        }
        
        return "admin/auditorium-detail";
    }

    @PostMapping("/auditoriums/{auditoriumId}/reset-seats")
    public String resetAuditoriumSeats(@PathVariable Long auditoriumId, RedirectAttributes redirectAttributes) {
        try {
            if (!singleCinemaService.isAuditoriumBelongsToOurCinema(auditoriumId)) {
                redirectAttributes.addFlashAttribute("error", "Phòng chiếu không thuộc về rạp này");
                return "redirect:/admin/theaters";
            }
            
            auditoriumService.resetSeatsForAuditorium(auditoriumId);
            redirectAttributes.addFlashAttribute("success", "Đã reset lại 50 ghế cho phòng chiếu thành công!");
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi khi reset ghế: " + e.getMessage());
        }
        
        return "redirect:/admin/theaters/auditoriums/" + auditoriumId;
    }

    @GetMapping("/api/cinema-stats")
    @ResponseBody
    public Object getCinemaStats() {
        try {
            return singleCinemaService.getCinemaStats();
        } catch (Exception e) {
            return Map.of("error", "Lỗi khi tải thống kê rạp: " + e.getMessage());
        }
    }

    @GetMapping("/api/auditoriums")
    @ResponseBody
    public List<Auditorium> getAllAuditoriums() {
        try {
            return singleCinemaService.getAllAuditoriums();
        } catch (Exception e) {
            return List.of();
        }
    }
    
    @GetMapping("/{theaterId}/auditoriums")
    @ResponseBody
    public List<Auditorium> getAuditoriumsByTheaterId(@PathVariable Long theaterId) {
        try {
            System.out.println("Getting auditoriums for theater ID: " + theaterId);
            List<Auditorium> auditoriums = auditoriumService.getAuditoriumsByTheaterId(theaterId);
            System.out.println("Found " + auditoriums.size() + " auditoriums");
            return auditoriums;
        } catch (Exception e) {
            System.out.println("Error getting auditoriums: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }
}
