package com.N07.CinemaProject.security;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

/**
 * Utility component để kiểm tra quyền trong Thymeleaf templates
 */
@Component("securityUtils")
public class SecurityUtils {
    
    /**
     * Kiểm tra xem user hiện tại có role ADMIN không
     */
    public boolean isAdmin() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) {
            return false;
        }
        return auth.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
    }
    
    /**
     * Kiểm tra xem user hiện tại có role THEATER_MANAGER không
     */
    public boolean isTheaterManager() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) {
            return false;
        }
        return auth.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_THEATER_MANAGER"));
    }
    
    /**
     * Kiểm tra xem user hiện tại có role CUSTOMER không
     */
    public boolean isCustomer() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) {
            return false;
        }
        return auth.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_CUSTOMER"));
    }
    
    /**
     * Kiểm tra xem user hiện tại có role MANAGER hoặc ADMIN không
     */
    public boolean isManagerOrAdmin() {
        return isAdmin() || isTheaterManager();
    }
    
    /**
     * Lấy tên user hiện tại (hiển thị tên đầy đủ nếu có)
     */
    public String getCurrentUsername() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getName())) {
            return null;
        }
        
        // If it's an OAuth2 user, try to get the full name
        if (auth.getPrincipal() instanceof com.N07.CinemaProject.security.CustomOAuth2User) {
            com.N07.CinemaProject.security.CustomOAuth2User customUser = 
                (com.N07.CinemaProject.security.CustomOAuth2User) auth.getPrincipal();
            return customUser.getFullName() != null ? customUser.getFullName() : customUser.getUsername();
        }
        
        return auth.getName();
    }
    
    /**
     * Lấy username thực tế (không phải display name)
     */
    public String getCurrentUsernameActual() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getName())) {
            return null;
        }
        
        if (auth.getPrincipal() instanceof com.N07.CinemaProject.security.CustomOAuth2User) {
            com.N07.CinemaProject.security.CustomOAuth2User customUser = 
                (com.N07.CinemaProject.security.CustomOAuth2User) auth.getPrincipal();
            return customUser.getUsername();
        }
        
        return auth.getName();
    }
    
    /**
     * Lấy role của user hiện tại
     */
    public String getCurrentUserRole() {
        if (isAdmin()) return "ADMIN";
        if (isTheaterManager()) return "THEATER_MANAGER";
        if (isCustomer()) return "CUSTOMER";
        return "ANONYMOUS";
    }
    
    /**
     * Kiểm tra xem user có đăng nhập không
     */
    public boolean isAuthenticated() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getName());
    }
}
