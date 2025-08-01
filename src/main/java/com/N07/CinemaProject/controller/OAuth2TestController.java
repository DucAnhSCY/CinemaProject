package com.N07.CinemaProject.controller;

import com.N07.CinemaProject.entity.User;
import com.N07.CinemaProject.service.CustomOAuth2User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequestMapping("/auth")
public class OAuth2TestController {
    
    @GetMapping("/oauth2/debug")
    public String debugAuth(@AuthenticationPrincipal OAuth2User oauth2User, Model model) {
        if (oauth2User != null) {
            model.addAttribute("attributes", oauth2User.getAttributes());
            model.addAttribute("authorities", oauth2User.getAuthorities());
            model.addAttribute("name", oauth2User.getName());
            
            if (oauth2User instanceof CustomOAuth2User) {
                CustomOAuth2User customUser = (CustomOAuth2User) oauth2User;
                User user = customUser.getUser();
                model.addAttribute("user", user);
                model.addAttribute("userEmail", user.getEmail());
                model.addAttribute("userId", user.getId());
                model.addAttribute("userRole", user.getRole());
                model.addAttribute("authProvider", user.getAuthProvider());
            }
            
            log.info("OAuth2 Debug - User: {}, Attributes: {}", 
                    oauth2User.getName(), oauth2User.getAttributes());
        } else {
            model.addAttribute("message", "No authenticated user found");
        }
        
        return "auth/debug";
    }
}
