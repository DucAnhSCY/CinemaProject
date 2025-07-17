package com.N07.CinemaProject.controller.admin;

import com.N07.CinemaProject.entity.Theater;
import com.N07.CinemaProject.entity.Auditorium;
import com.N07.CinemaProject.repository.TheaterRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin/theaters")
public class AdminTheaterController {

    @Autowired
    private TheaterRepository theaterRepository;

    @GetMapping
    public String listTheaters(Model model) {
        List<Theater> theaters = theaterRepository.findAll();
        model.addAttribute("theaters", theaters);
        return "admin/theater-management";
    }

    @GetMapping("/add")
    public String addTheaterForm(Model model) {
        model.addAttribute("theater", new Theater());
        return "admin/theater-form";
    }

    @PostMapping("/add")
    public String addTheater(@ModelAttribute Theater theater, RedirectAttributes redirectAttributes) {
        try {
            theaterRepository.save(theater);
            redirectAttributes.addFlashAttribute("success", "Đã thêm rạp chiếu thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi khi thêm rạp chiếu: " + e.getMessage());
        }
        return "redirect:/admin/theaters";
    }

    @GetMapping("/{id}/edit")
    public String editTheaterForm(@PathVariable Long id, Model model) {
        Optional<Theater> theater = theaterRepository.findById(id);
        if (theater.isPresent()) {
            model.addAttribute("theater", theater.get());
            return "admin/theater-form";
        }
        return "redirect:/admin/theaters?error=Theater not found";
    }

    @PostMapping("/{id}/edit")
    public String editTheater(@PathVariable Long id, @ModelAttribute Theater theater, RedirectAttributes redirectAttributes) {
        try {
            theater.setId(id);
            theaterRepository.save(theater);
            redirectAttributes.addFlashAttribute("success", "Đã cập nhật rạp chiếu thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi khi cập nhật rạp chiếu: " + e.getMessage());
        }
        return "redirect:/admin/theaters";
    }

    @GetMapping("/{id}/auditoriums")
    @ResponseBody
    public List<Auditorium> getAuditoriumsByTheater(@PathVariable Long id) {
        Optional<Theater> theater = theaterRepository.findById(id);
        if (theater.isPresent()) {
            return theater.get().getAuditoriums();
        }
        return List.of();
    }

    @DeleteMapping("/{id}")
    @ResponseBody
    public String deleteTheater(@PathVariable Long id) {
        try {
            theaterRepository.deleteById(id);
            return "success";
        } catch (Exception e) {
            return "error";
        }
    }
}
