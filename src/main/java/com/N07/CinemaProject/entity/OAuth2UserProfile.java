package com.N07.CinemaProject.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import com.fasterxml.jackson.annotation.JsonIgnore;

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
    
    @OneToOne
    @JoinColumn(name = "user_id", nullable = false)
    @JsonIgnore
    private User user;
    
    @Column(name = "provider_name", nullable = false)
    private String providerName; // google, github
    
    @Column(name = "provider_user_id", nullable = false)
    private String providerUserId; // ID từ OAuth provider
    
    @Column(name = "provider_username")
    private String providerUsername; // Username từ provider (nếu có)
    
    @Column(name = "provider_email", nullable = false)
    private String providerEmail;
    
    @Column(name = "provider_name_display")
    private String providerNameDisplay; // Tên hiển thị từ provider
    
    @Column(name = "provider_avatar_url")
    private String providerAvatarUrl;
    
    @Column(name = "provider_profile_url")
    private String providerProfileUrl; // Link đến profile gốc
    
    @Column(name = "access_token", length = 2048)
    private String accessToken; // Lưu để có thể call API sau này
    
    @Column(name = "refresh_token", length = 2048)
    private String refreshToken;
    
    @Column(name = "token_expires_at")
    private LocalDateTime tokenExpiresAt;
    
    @Column(name = "raw_attributes", columnDefinition = "NTEXT")
    private String rawAttributes; // JSON string của toàn bộ attributes từ provider
    
    @Column(name = "first_login")
    private LocalDateTime firstLogin; // Lần đầu login qua OAuth
    
    @Column(name = "last_login")
    private LocalDateTime lastLogin;
    
    @Column(name = "login_count")
    private Integer loginCount = 0;
    
    @Column(name = "is_active")
    private Boolean isActive = true;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (firstLogin == null) {
            firstLogin = LocalDateTime.now();
        }
        if (lastLogin == null) {
            lastLogin = LocalDateTime.now();
        }
        if (loginCount == null) {
            loginCount = 1;
        }
        if (isActive == null) {
            isActive = true;
        }
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
    
    public void incrementLoginCount() {
        this.loginCount = (this.loginCount == null) ? 1 : this.loginCount + 1;
        this.lastLogin = LocalDateTime.now();
    }
}
