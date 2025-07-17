package com.N07.CinemaProject.controller;

import com.N07.CinemaProject.entity.User;
import com.N07.CinemaProject.security.CustomOAuth2User;
import com.N07.CinemaProject.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Controller
public class AuthDebugController {

    @Autowired
    private UserService userService;

    @GetMapping("/auth/debug")
    @ResponseBody
    public Map<String, Object> debugAuth() {
        Map<String, Object> result = new HashMap<>();
        
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null) {
            result.put("authenticated", auth.isAuthenticated());
            result.put("name", auth.getName());
            result.put("authorities", auth.getAuthorities());
            result.put("principalType", auth.getPrincipal().getClass().getSimpleName());
            
            if (auth.getPrincipal() instanceof CustomOAuth2User) {
                CustomOAuth2User customUser = (CustomOAuth2User) auth.getPrincipal();
                result.put("customUser", Map.of(
                    "id", customUser.getId(),
                    "username", customUser.getUsername(),
                    "fullName", customUser.getFullName(),
                    "email", customUser.getEmail(),
                    "role", customUser.getRole(),
                    "avatarUrl", customUser.getAvatarUrl()
                ));
            } else if (auth.getPrincipal() instanceof OAuth2User) {
                OAuth2User oauth2User = (OAuth2User) auth.getPrincipal();
                result.put("oauth2Attributes", oauth2User.getAttributes());
            }
            
            // Get user from database
            Optional<User> currentUser = userService.getCurrentUser();
            if (currentUser.isPresent()) {
                User user = currentUser.get();
                result.put("dbUser", Map.of(
                    "id", user.getId(),
                    "username", user.getUsername(),
                    "fullName", user.getFullName() != null ? user.getFullName() : "null",
                    "email", user.getEmail(),
                    "role", user.getRole(),
                    "authProvider", user.getAuthProvider(),
                    "providerId", user.getProviderId() != null ? user.getProviderId() : "null"
                ));
            } else {
                result.put("dbUser", "not found");
            }
        } else {
            result.put("authenticated", false);
        }
        
        return result;
    }
}
