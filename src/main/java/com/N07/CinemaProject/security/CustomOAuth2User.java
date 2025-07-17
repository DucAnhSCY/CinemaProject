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
        // Trả về tên đầy đủ thay vì ID
        if (user.getFullName() != null && !user.getFullName().isEmpty()) {
            return user.getFullName();
        }
        // Fallback to username if fullName is null
        if (user.getUsername() != null && !user.getUsername().isEmpty()) {
            return user.getUsername();
        }
        // Fallback to email if username is null
        if (user.getEmail() != null && !user.getEmail().isEmpty()) {
            return user.getEmail();
        }
        // Last resort: use the OAuth2 name attribute
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
}
