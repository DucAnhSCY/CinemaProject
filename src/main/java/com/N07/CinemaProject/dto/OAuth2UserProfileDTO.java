package com.N07.CinemaProject.dto;

import com.N07.CinemaProject.entity.OAuth2UserProfile;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OAuth2UserProfileDTO {
    private Long id;
    private Long userId;
    private String userEmail;
    private String userFullName;
    private String providerName;
    private String providerUserId;
    private String providerUsername;
    private String providerEmail;
    private String providerNameDisplay;
    private String providerAvatarUrl;
    private String providerProfileUrl;
    private LocalDateTime firstLogin;
    private LocalDateTime lastLogin;
    private Integer loginCount;
    private Boolean isActive;
    
    public static OAuth2UserProfileDTO fromEntity(OAuth2UserProfile profile) {
        if (profile == null) return null;
        
        OAuth2UserProfileDTO dto = new OAuth2UserProfileDTO();
        dto.setId(profile.getId());
        dto.setUserId(profile.getUser().getId());
        dto.setUserEmail(profile.getUser().getEmail());
        dto.setUserFullName(profile.getUser().getFullName());
        dto.setProviderName(profile.getProviderName());
        dto.setProviderUserId(profile.getProviderUserId());
        dto.setProviderUsername(profile.getProviderUsername());
        dto.setProviderEmail(profile.getProviderEmail());
        dto.setProviderNameDisplay(profile.getProviderNameDisplay());
        dto.setProviderAvatarUrl(profile.getProviderAvatarUrl());
        dto.setProviderProfileUrl(profile.getProviderProfileUrl());
        dto.setFirstLogin(profile.getFirstLogin());
        dto.setLastLogin(profile.getLastLogin());
        dto.setLoginCount(profile.getLoginCount());
        dto.setIsActive(profile.getIsActive());
        
        return dto;
    }
}
