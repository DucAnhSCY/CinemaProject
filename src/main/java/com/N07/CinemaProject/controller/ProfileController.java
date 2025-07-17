package com.N07.CinemaProject.controller;

import com.N07.CinemaProject.entity.User;
import com.N07.CinemaProject.security.CustomOAuth2User;
import com.N07.CinemaProject.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.Optional;

@Controller
public class ProfileController {

    @Autowired
    private UserService userService;

    @GetMapping("/profile")
    public String profile(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        
        if (auth != null && auth.isAuthenticated() && !auth.getName().equals("anonymousUser")) {
            model.addAttribute("authName", auth.getName());
            
            // Get user from database via UserService
            Optional<User> currentUser = userService.getCurrentUser();
            if (currentUser.isPresent()) {
                User user = currentUser.get();
                model.addAttribute("user", user);
                
                // For OAuth users, add additional display info
                if (auth.getPrincipal() instanceof CustomOAuth2User) {
                    CustomOAuth2User customUser = (CustomOAuth2User) auth.getPrincipal();
                    model.addAttribute("displayName", customUser.getFullName() != null ? customUser.getFullName() : customUser.getUsername());
                    model.addAttribute("isOAuth", true);
                    model.addAttribute("avatarUrl", customUser.getAvatarUrl());
                } else {
                    model.addAttribute("displayName", user.getFullName() != null ? user.getFullName() : user.getUsername());
                    model.addAttribute("isOAuth", false);
                }
            } else {
                // User not found in database, redirect to login
                return "redirect:/auth/login";
            }
        } else {
            // User not authenticated, redirect to login
            return "redirect:/auth/login";
        }
        
        return "pages/profile";
    }
}
