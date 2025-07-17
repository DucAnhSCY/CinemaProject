package com.N07.CinemaProject.controller;

import com.N07.CinemaProject.entity.Theater;
import com.N07.CinemaProject.service.TheaterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/theaters")
public class TheaterController {
    
    @Autowired
    private TheaterService theaterService;
    
    @GetMapping
    public String allTheaters(Model model, HttpServletRequest request) {
        model.addAttribute("currentPath", request.getRequestURI());
        try {
            List<Theater> theaters = theaterService.getAllTheaters();
            model.addAttribute("theaters", theaters);
            model.addAttribute("totalTheaters", theaters.size());
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi tải danh sách rạp: " + e.getMessage());
            model.addAttribute("theaters", List.of());
        }
        return "pages/theaters";
    }
    
    @GetMapping("/{id}")
    public String theaterDetail(@PathVariable Long id, Model model, HttpServletRequest request) {
        model.addAttribute("currentPath", request.getRequestURI());
        try {
            Optional<Theater> theater = theaterService.getTheaterById(id);
            if (theater.isPresent()) {
                model.addAttribute("theater", theater.get());
                return "pages/theater-detail";
            } else {
                model.addAttribute("error", "Không tìm thấy rạp phim này");
                return "redirect:/theaters";
            }
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi tải thông tin rạp: " + e.getMessage());
            return "redirect:/theaters";
        }
    }
    
    @GetMapping("/search")
    public String searchTheaters(@RequestParam(required = false) String name,
                               @RequestParam(required = false) String location,
                               Model model, HttpServletRequest request) {
        model.addAttribute("currentPath", request.getRequestURI());
        try {
            List<Theater> theaters = theaterService.searchTheaters(name, location);
            model.addAttribute("theaters", theaters);
            model.addAttribute("searchName", name);
            model.addAttribute("searchLocation", location);
            model.addAttribute("totalTheaters", theaters.size());
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi tìm kiếm rạp: " + e.getMessage());
            model.addAttribute("theaters", List.of());
        }
        return "pages/theaters";
    }
}
