package com.N07.CinemaProject.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/promotions")
public class PromotionController {
    
    @GetMapping
    public String allPromotions(Model model, HttpServletRequest request) {
        model.addAttribute("currentPath", request.getRequestURI());
        // For now, we'll just return a simple promotions page
        // You can add promotion entities and service later
        return "pages/promotions";
    }
}
