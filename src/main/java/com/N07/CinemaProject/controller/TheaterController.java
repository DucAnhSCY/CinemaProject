package com.N07.CinemaProject.controller;

import com.N07.CinemaProject.service.SingleCinemaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/theaters")
public class TheaterController {
    
    @Autowired
    private SingleCinemaService singleCinemaService;
    
    @GetMapping
    public String cinemaInfo(Model model, HttpServletRequest request) {
        model.addAttribute("currentPath", request.getRequestURI());
        try {
            // Lấy thông tin rạp duy nhất và các phòng chiếu
            SingleCinemaService.CinemaInfo cinemaInfo = singleCinemaService.getCinemaInfo();
            model.addAttribute("cinemaInfo", cinemaInfo);
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi tải thông tin rạp: " + e.getMessage());
            model.addAttribute("cinemaInfo", null);
        }
        return "pages/theaters";
    }
}
