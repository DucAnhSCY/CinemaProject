package com.N07.CinemaProject.service;

import com.N07.CinemaProject.entity.OAuth2UserProfile;
import com.N07.CinemaProject.entity.User;
import com.N07.CinemaProject.repository.OAuth2UserProfileRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
@Transactional
public class OAuth2UserProfileService {
    
    @Autowired
    private OAuth2UserProfileRepository oauth2UserProfileRepository;
    
    @Autowired
    private ObjectMapper objectMapper;
    
    public Optional<OAuth2UserProfile> findByUser(User user) {
        return oauth2UserProfileRepository.findByUser(user);
    }
    
    public Optional<OAuth2UserProfile> findByProviderAndUserId(String providerName, String providerUserId) {
        return oauth2UserProfileRepository.findByProviderNameAndProviderUserId(providerName, providerUserId);
    }
    
    public Optional<OAuth2UserProfile> findByProviderAndEmail(String providerName, String providerEmail) {
        return oauth2UserProfileRepository.findByProviderNameAndProviderEmail(providerName, providerEmail);
    }
    
    public Optional<OAuth2UserProfile> findByUserId(Long userId) {
        return oauth2UserProfileRepository.findByUserId(userId);
    }
    
    public OAuth2UserProfile save(OAuth2UserProfile profile) {
        return oauth2UserProfileRepository.save(profile);
    }
    
    public OAuth2UserProfile createOrUpdateProfile(User user, String providerName, 
                                                 String providerUserId, String providerEmail,
                                                 String providerUsername, String providerNameDisplay,
                                                 String providerAvatarUrl, String providerProfileUrl,
                                                 String accessToken, String refreshToken,
                                                 LocalDateTime tokenExpiresAt,
                                                 Map<String, Object> rawAttributes) {
        
        OAuth2UserProfile profile = oauth2UserProfileRepository.findByUser(user)
                .orElse(new OAuth2UserProfile());
        
        profile.setUser(user);
        profile.setProviderName(providerName);
        profile.setProviderUserId(providerUserId);
        profile.setProviderEmail(providerEmail);
        profile.setProviderUsername(providerUsername);
        profile.setProviderNameDisplay(providerNameDisplay);
        profile.setProviderAvatarUrl(providerAvatarUrl);
        profile.setProviderProfileUrl(providerProfileUrl);
        profile.setAccessToken(accessToken);
        profile.setRefreshToken(refreshToken);
        profile.setTokenExpiresAt(tokenExpiresAt);
        
        // Convert raw attributes to JSON string
        try {
            if (rawAttributes != null) {
                profile.setRawAttributes(objectMapper.writeValueAsString(rawAttributes));
            }
        } catch (JsonProcessingException e) {
            System.err.println("Error serializing OAuth2 attributes: " + e.getMessage());
        }
        
        // Increment login count
        profile.incrementLoginCount();
        
        return oauth2UserProfileRepository.save(profile);
    }
    
    public void updateLastLogin(OAuth2UserProfile profile) {
        profile.incrementLoginCount();
        oauth2UserProfileRepository.save(profile);
    }
    
    public void deactivateProfile(Long profileId) {
        oauth2UserProfileRepository.findById(profileId)
                .ifPresent(profile -> {
                    profile.setIsActive(false);
                    oauth2UserProfileRepository.save(profile);
                });
    }
    
    public void activateProfile(Long profileId) {
        oauth2UserProfileRepository.findById(profileId)
                .ifPresent(profile -> {
                    profile.setIsActive(true);
                    oauth2UserProfileRepository.save(profile);
                });
    }
    
    public List<OAuth2UserProfile> findActiveProfilesByProvider(String providerName) {
        return oauth2UserProfileRepository.findActiveProfilesByProvider(providerName);
    }
    
    public List<OAuth2UserProfile> findRecentLogins(LocalDateTime since) {
        return oauth2UserProfileRepository.findRecentLogins(since);
    }
    
    public Long countActiveUsersByProvider(String providerName) {
        return oauth2UserProfileRepository.countActiveUsersByProvider(providerName);
    }
    
    public boolean existsByProviderAndUserId(String providerName, String providerUserId) {
        return oauth2UserProfileRepository.existsByProviderNameAndProviderUserId(providerName, providerUserId);
    }
    
    /**
     * Parse raw attributes JSON string back to Map
     */
    @SuppressWarnings("unchecked")
    public Map<String, Object> parseRawAttributes(String rawAttributesJson) {
        try {
            if (rawAttributesJson != null && !rawAttributesJson.trim().isEmpty()) {
                return objectMapper.readValue(rawAttributesJson, Map.class);
            }
        } catch (JsonProcessingException e) {
            System.err.println("Error deserializing OAuth2 attributes: " + e.getMessage());
        }
        return null;
    }
}
