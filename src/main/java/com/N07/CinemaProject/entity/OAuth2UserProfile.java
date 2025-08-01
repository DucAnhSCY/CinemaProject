package com.N07.CinemaProject.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "oauth2_user_profiles")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class OAuth2UserProfile {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;
    
    @Column(name = "provider_id", unique = true)
    private String providerId;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "provider")
    private User.AuthProvider provider;
    
    @Column(name = "provider_username")
    private String providerUsername;
    
    @Column(name = "access_token", columnDefinition = "TEXT")
    private String accessToken;
    
    @Column(name = "refresh_token", columnDefinition = "TEXT")
    private String refreshToken;
    
    @Column(name = "token_expiry")
    private LocalDateTime tokenExpiry;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    // Additional profile information from OAuth2 providers
    @Column(name = "picture_url")
    private String pictureUrl;
    
    @Column(name = "locale")
    private String locale;
    
    @Column(name = "verified_email")
    private Boolean verifiedEmail;
    
    @Column(name = "family_name")
    private String familyName;
    
    @Column(name = "given_name")
    private String givenName;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
