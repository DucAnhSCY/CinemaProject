package com.N07.CinemaProject.controller;

import com.N07.CinemaProject.entity.User;
import com.N07.CinemaProject.repository.UserRepository;
import com.N07.CinemaProject.security.CustomOAuth2User;
import com.N07.CinemaProject.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
public class UserTestController {

    @Autowired
    private UserService userService;
    
    @Autowired
    private UserRepository userRepository;

    @GetMapping("/test/oauth-users")
    @ResponseBody
    public Map<String, Object> testOAuthUsers() {
        Map<String, Object> result = new HashMap<>();
        
        // Get current authentication
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated()) {
            result.put("authenticated", true);
            result.put("authName", auth.getName());
            result.put("principalType", auth.getPrincipal().getClass().getSimpleName());
            
            if (auth.getPrincipal() instanceof CustomOAuth2User) {
                CustomOAuth2User customUser = (CustomOAuth2User) auth.getPrincipal();
                result.put("customUser", Map.of(
                    "id", customUser.getId(),
                    "username", customUser.getUsername(),
                    "fullName", customUser.getFullName() != null ? customUser.getFullName() : "null",
                    "email", customUser.getEmail(),
                    "role", customUser.getRole(),
                    "avatarUrl", customUser.getAvatarUrl() != null ? customUser.getAvatarUrl() : "null",
                    "authProvider", customUser.getUser().getAuthProvider()
                ));
            }
        } else {
            result.put("authenticated", false);
        }
        
        // Get OAuth users from database
        List<User> allUsers = userRepository.findAll();
        List<User> oauthUsers = allUsers.stream()
            .filter(user -> user.getAuthProvider() != User.AuthProvider.LOCAL)
            .toList();
            
        result.put("totalUsers", allUsers.size());
        result.put("oauthUsersCount", oauthUsers.size());
        result.put("oauthUsers", oauthUsers.stream().map(user -> Map.of(
            "id", user.getId(),
            "username", user.getUsername(),
            "fullName", user.getFullName() != null ? user.getFullName() : "null",
            "email", user.getEmail(),
            "authProvider", user.getAuthProvider(),
            "providerId", user.getProviderId() != null ? user.getProviderId() : "null",
            "avatarUrl", user.getAvatarUrl() != null ? user.getAvatarUrl() : "null",
            "createdAt", user.getCreatedAt(),
            "lastLogin", user.getLastLogin()
        )).toList());
        
        return result;
    }
    
    @GetMapping("/test/current-user")
    @ResponseBody
    public Map<String, Object> testCurrentUser() {
        Map<String, Object> result = new HashMap<>();
        
        Optional<User> currentUser = userService.getCurrentUser();
        if (currentUser.isPresent()) {
            User user = currentUser.get();
            result.put("found", true);
            result.put("user", Map.of(
                "id", user.getId(),
                "username", user.getUsername(),
                "fullName", user.getFullName() != null ? user.getFullName() : "null",
                "email", user.getEmail(),
                "role", user.getRole(),
                "authProvider", user.getAuthProvider(),
                "providerId", user.getProviderId() != null ? user.getProviderId() : "null",
                "avatarUrl", user.getAvatarUrl() != null ? user.getAvatarUrl() : "null"
            ));
        } else {
            result.put("found", false);
        }
        
        return result;
    }
}
