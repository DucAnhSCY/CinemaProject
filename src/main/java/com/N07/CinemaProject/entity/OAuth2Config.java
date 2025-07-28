package com.N07.CinemaProject.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "oauth2_configs")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class OAuth2Config {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "provider_name", nullable = false, unique = true)
    private String providerName; // google, github, etc.
    
    @Column(name = "client_id", nullable = false)
    private String clientId;
    
    @Column(name = "client_secret", nullable = false)
    private String clientSecret;
    
    @Column(name = "authorization_uri")
    private String authorizationUri;
    
    @Column(name = "token_uri")
    private String tokenUri;
    
    @Column(name = "user_info_uri")
    private String userInfoUri;
    
    @Column(name = "redirect_uri")
    private String redirectUri;
    
    @Column(name = "scope")
    private String scope;
    
    @Column(name = "is_enabled")
    private Boolean isEnabled = true;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (isEnabled == null) {
            isEnabled = true;
        }
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
