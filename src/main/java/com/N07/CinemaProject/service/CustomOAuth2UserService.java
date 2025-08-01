package com.N07.CinemaProject.service;

import com.N07.CinemaProject.entity.OAuth2UserProfile;
import com.N07.CinemaProject.entity.User;
import com.N07.CinemaProject.repository.OAuth2UserProfileRepository;
import com.N07.CinemaProject.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class CustomOAuth2UserService extends DefaultOAuth2UserService {
    
    private final UserRepository userRepository;
    private final OAuth2UserProfileRepository oauth2UserProfileRepository;
    
    @Override
    @Transactional
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2User oauth2User = super.loadUser(userRequest);
        
        try {
            return processOAuth2User(userRequest, oauth2User);
        } catch (Exception ex) {
            log.error("Error processing OAuth2 user", ex);
            throw new OAuth2AuthenticationException("Error processing OAuth2 user: " + ex.getMessage());
        }
    }
    
    private OAuth2User processOAuth2User(OAuth2UserRequest userRequest, OAuth2User oauth2User) {
        String registrationId = userRequest.getClientRegistration().getRegistrationId();
        User.AuthProvider authProvider = getAuthProvider(registrationId);
        
        Map<String, Object> attributes = oauth2User.getAttributes();
        OAuth2UserInfo userInfo = OAuth2UserInfoFactory.getOAuth2UserInfo(registrationId, attributes);
        
        if (userInfo.getEmail() == null || userInfo.getEmail().isEmpty()) {
            throw new OAuth2AuthenticationException("Email not found from OAuth2 provider");
        }
        
        Optional<User> userOptional = userRepository.findByEmail(userInfo.getEmail());
        User user;
        
        if (userOptional.isPresent()) {
            user = userOptional.get();
            if (!user.getAuthProvider().equals(authProvider)) {
                throw new OAuth2AuthenticationException(
                    "Looks like you're signed up with " + user.getAuthProvider() + 
                    " account. Please use your " + user.getAuthProvider() + " account to login."
                );
            }
            
            // Check if user account is disabled
            if (!user.getIsEnabled()) {
                throw new OAuth2AuthenticationException(
                    "Your account has been disabled. Please contact the administrator for assistance."
                );
            }
            
            user = updateExistingUser(user, userInfo);
        } else {
            user = registerNewUser(userRequest, userInfo, authProvider);
        }
        
        // Update or create OAuth2 profile
        updateOAuth2Profile(user, userRequest, userInfo, authProvider);
        
        // Update last login
        user.setLastLogin(LocalDateTime.now());
        userRepository.save(user);
        
        return new CustomOAuth2User(oauth2User.getAttributes(), user);
    }
    
    private User registerNewUser(OAuth2UserRequest userRequest, OAuth2UserInfo userInfo, User.AuthProvider authProvider) {
        User user = new User();
        user.setProviderId(userInfo.getId());
        user.setFullName(userInfo.getName());
        user.setEmail(userInfo.getEmail());
        user.setAvatarUrl(userInfo.getImageUrl());
        user.setAuthProvider(authProvider);
        user.setRole(User.Role.CUSTOMER); // Default role
        user.setIsEnabled(true);
        
        // Generate username from email
        String username = generateUsername(userInfo.getEmail());
        user.setUsername(username);
        
        log.info("Registering new user with email: {}", userInfo.getEmail());
        return userRepository.save(user);
    }
    
    private User updateExistingUser(User existingUser, OAuth2UserInfo userInfo) {
        existingUser.setFullName(userInfo.getName());
        existingUser.setAvatarUrl(userInfo.getImageUrl());
        return userRepository.save(existingUser);
    }
    
    private void updateOAuth2Profile(User user, OAuth2UserRequest userRequest, OAuth2UserInfo userInfo, User.AuthProvider authProvider) {
        Optional<OAuth2UserProfile> profileOptional = oauth2UserProfileRepository.findByUser(user);
        OAuth2UserProfile profile;
        
        if (profileOptional.isPresent()) {
            profile = profileOptional.get();
        } else {
            profile = new OAuth2UserProfile();
            profile.setUser(user);
            profile.setProvider(authProvider);
            profile.setProviderId(userInfo.getId());
        }
        
        // Update profile information
        profile.setProviderUsername(userInfo.getName());
        profile.setPictureUrl(userInfo.getImageUrl());
        
        if (userInfo instanceof GoogleOAuth2UserInfo) {
            GoogleOAuth2UserInfo googleInfo = (GoogleOAuth2UserInfo) userInfo;
            profile.setLocale(googleInfo.getLocale());
            profile.setVerifiedEmail(googleInfo.getVerifiedEmail());
            profile.setFamilyName(googleInfo.getFamilyName());
            profile.setGivenName(googleInfo.getGivenName());
        }
        
        // Store access token if available
        if (userRequest.getAccessToken() != null) {
            profile.setAccessToken(userRequest.getAccessToken().getTokenValue());
            var expiresAt = userRequest.getAccessToken().getExpiresAt();
            if (expiresAt != null) {
                profile.setTokenExpiry(expiresAt.atZone(java.time.ZoneId.systemDefault()).toLocalDateTime());
            }
        }
        
        oauth2UserProfileRepository.save(profile);
    }
    
    private String generateUsername(String email) {
        String baseUsername = email.split("@")[0];
        String username = baseUsername;
        int counter = 1;
        
        while (userRepository.findByUsername(username).isPresent()) {
            username = baseUsername + counter;
            counter++;
        }
        
        return username;
    }
    
    private User.AuthProvider getAuthProvider(String registrationId) {
        return switch (registrationId.toLowerCase()) {
            case "google" -> User.AuthProvider.GOOGLE;
            default -> throw new OAuth2AuthenticationException("Sorry! Login with " + registrationId + " is not supported yet.");
        };
    }
}
