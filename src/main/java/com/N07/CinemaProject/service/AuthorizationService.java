package com.N07.CinemaProject.service;

import com.N07.CinemaProject.entity.User;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

@Service
public class AuthorizationService {

    /**
     * Check if current user has ADMIN role
     */
    public boolean isAdmin() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) {
            return false;
        }
        
        return auth.getAuthorities().stream()
                .anyMatch(grantedAuthority -> grantedAuthority.getAuthority().equals("ROLE_ADMIN"));
    }

    /**
     * Check if current user has THEATER_MANAGER role
     */
    public boolean isTheaterManager() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) {
            return false;
        }
        
        return auth.getAuthorities().stream()
                .anyMatch(grantedAuthority -> grantedAuthority.getAuthority().equals("ROLE_THEATER_MANAGER"));
    }

    /**
     * Check if current user has admin or theater manager role
     */
    public boolean canAccessAdminArea() {
        return isAdmin() || isTheaterManager();
    }

    /**
     * Check if current user can manage users (only ADMIN)
     */
    public boolean canManageUsers() {
        return isAdmin();
    }

    /**
     * Check if current user can manage a specific user
     * THEATER_MANAGER cannot manage ADMIN users
     */
    public boolean canManageUser(User targetUser) {
        if (isAdmin()) {
            return true; // Admin can manage anyone
        }
        
        if (isTheaterManager()) {
            // Theater manager cannot manage admin users
            return targetUser.getRole() != User.Role.ADMIN;
        }
        
        return false;
    }

    /**
     * Get current user's role
     */
    public User.Role getCurrentUserRole() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) {
            return null;
        }

        if (isAdmin()) {
            return User.Role.ADMIN;
        } else if (isTheaterManager()) {
            return User.Role.THEATER_MANAGER;
        } else {
            return User.Role.CUSTOMER;
        }
    }

    /**
     * Get current user's username
     */
    public String getCurrentUsername() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) {
            return null;
        }

        Object principal = auth.getPrincipal();
        if (principal instanceof CustomOAuth2User) {
            return ((CustomOAuth2User) principal).getName();
        } else if (principal instanceof UserDetails) {
            return ((UserDetails) principal).getUsername();
        } else {
            return principal.toString();
        }
    }
}
