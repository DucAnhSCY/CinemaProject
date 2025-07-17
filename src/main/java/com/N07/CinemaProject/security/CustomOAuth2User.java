package com.N07.CinemaProject.security;

import com.N07.CinemaProject.entity.User;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.core.user.OAuth2User;

import java.util.Collection;
import java.util.Collections;
import java.util.Map;

/**
 * Custom OAuth2User implementation để quản lý thông tin user OAuth2
 */
public class CustomOAuth2User implements OAuth2User {
    private final User user;
    private final Map<String, Object> attributes;
    private final String nameAttributeKey;

    public CustomOAuth2User(User user, Map<String, Object> attributes, String nameAttributeKey) {
        this.user = user;
        this.attributes = attributes;
        this.nameAttributeKey = nameAttributeKey;
    }

    @Override
    public Map<String, Object> getAttributes() {
        return attributes;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return Collections.singleton(new SimpleGrantedAuthority("ROLE_" + user.getRole().name()));
    }

    @Override
    public String getName() {
        // Ưu tiên hiển thị tên đầy đủ từ Google
        if (user.getFullName() != null && !user.getFullName().trim().isEmpty()) {
            return user.getFullName().trim();
        }
        
        // Nếu không có fullName trong database, lấy từ OAuth attributes
        Object nameFromOAuth = attributes.get("name");
        if (nameFromOAuth != null && !nameFromOAuth.toString().trim().isEmpty()) {
            return nameFromOAuth.toString().trim();
        }
        
        // Fallback to username if available
        if (user.getUsername() != null && !user.getUsername().trim().isEmpty()) {
            return user.getUsername().trim();
        }
        
        // Fallback to email local part
        if (user.getEmail() != null && !user.getEmail().trim().isEmpty()) {
            String email = user.getEmail().trim();
            return email.split("@")[0];
        }
        
        // Last resort: use the OAuth2 ID attribute
        return attributes.get(nameAttributeKey).toString();
    }

    /**
     * Get the User entity
     */
    public User getUser() {
        return user;
    }

    /**
     * Get user ID
     */
    public Long getId() {
        return user.getId();
    }

    /**
     * Get email
     */
    public String getEmail() {
        return user.getEmail();
    }

    /**
     * Get full name
     */
    public String getFullName() {
        return user.getFullName();
    }

    /**
     * Get avatar URL
     */
    public String getAvatarUrl() {
        return user.getAvatarUrl();
    }

    /**
     * Get role
     */
    public User.Role getRole() {
        return user.getRole();
    }

    /**
     * Get username (for compatibility)
     */
    public String getUsername() {
        return user.getUsername();
    }
    
    /**
     * Get display name for UI - prioritizes fullName over username
     */
    public String getDisplayName() {
        if (user.getFullName() != null && !user.getFullName().trim().isEmpty()) {
            return user.getFullName().trim();
        }
        
        // Fallback to name from OAuth attributes
        Object nameFromOAuth = attributes.get("name");
        if (nameFromOAuth != null && !nameFromOAuth.toString().trim().isEmpty()) {
            return nameFromOAuth.toString().trim();
        }
        
        if (user.getUsername() != null && !user.getUsername().trim().isEmpty()) {
            return user.getUsername().trim();
        }
        
        if (user.getEmail() != null && !user.getEmail().trim().isEmpty()) {
            String email = user.getEmail().trim();
            return email.split("@")[0];
        }
        
        return "Người dùng";
    }
}
