package com.N07.CinemaProject.service;
import com.N07.CinemaProject.entity.User;
import com.N07.CinemaProject.security.CustomOAuth2User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.Optional;

@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService {
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private OAuth2UserProfileService oauth2UserProfileService;
    
    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2User oauth2User = super.loadUser(userRequest);
        
        String registrationId = userRequest.getClientRegistration().getRegistrationId();
        Map<String, Object> attributes = oauth2User.getAttributes();
        
        try {
            User user = processOAuth2User(registrationId, attributes, userRequest);
            
            // Return custom OAuth2User with proper name handling
            return new CustomOAuth2User(user, attributes, getNameAttributeKey(registrationId));
        } catch (Exception e) {
            throw new OAuth2AuthenticationException("Error processing OAuth2 user: " + e.getMessage());
        }
    }
    
    private User processOAuth2User(String registrationId, Map<String, Object> attributes, OAuth2UserRequest userRequest) {
        String email;
        String name;
        String avatarUrl = null;
        String providerId;
        String providerProfileUrl = null;
        User.AuthProvider provider;
        
        // Extract access token from the request
        String accessToken = userRequest.getAccessToken().getTokenValue();
        LocalDateTime tokenExpiresAt = null;
        if (userRequest.getAccessToken().getExpiresAt() != null) {
            tokenExpiresAt = LocalDateTime.ofInstant(
                userRequest.getAccessToken().getExpiresAt(), 
                java.time.ZoneId.systemDefault()
            );
        }
        
        if ("google".equals(registrationId)) {
            provider = User.AuthProvider.GOOGLE;
            email = (String) attributes.get("email");
            name = (String) attributes.get("name");
            avatarUrl = (String) attributes.get("picture");
            providerId = (String) attributes.get("sub");
            providerProfileUrl = "https://accounts.google.com/" + providerId;
            
            // Log thông tin để debug
            System.out.println("Google OAuth - Email: " + email + ", Name: " + name + ", Avatar: " + avatarUrl);
        } else if ("github".equals(registrationId)) {
            provider = User.AuthProvider.GITHUB;
            email = (String) attributes.get("email");
            name = (String) attributes.get("name");
            avatarUrl = (String) attributes.get("avatar_url");
            providerId = String.valueOf(attributes.get("id"));
            providerProfileUrl = (String) attributes.get("html_url");
            
            // Log thông tin để debug
            System.out.println("GitHub OAuth - Email: " + email + ", Name: " + name + ", Avatar: " + avatarUrl);
        } else {
            throw new OAuth2AuthenticationException("Unsupported provider: " + registrationId);
        }
        
        if (email == null || email.isEmpty()) {
            throw new OAuth2AuthenticationException("Email not found from OAuth2 provider");
        }
        
        if (name == null || name.isEmpty()) {
            // Use email as name if name is not provided
            name = email.split("@")[0];
        }
        
        // Check if user exists by provider ID
        Optional<User> existingUserByProvider = userService.findByProviderId(providerId, provider);
        if (existingUserByProvider.isPresent()) {
            // Update existing OAuth user
            User existingUser = existingUserByProvider.get();
            User updatedUser = userService.updateOAuthUser(existingUser, name, avatarUrl);
            
            // Update OAuth2 profile
            oauth2UserProfileService.createOrUpdateProfile(
                updatedUser, registrationId, providerId, email, 
                (String) attributes.get("login"), // username for GitHub, null for Google
                name, avatarUrl, providerProfileUrl, 
                accessToken, null, tokenExpiresAt, attributes
            );
            
            return updatedUser;
        }
        
        // Check if user exists by email
        Optional<User> existingUserByEmail = userService.findByEmail(email);
        if (existingUserByEmail.isPresent()) {
            User existingUser = existingUserByEmail.get();
            if (existingUser.getAuthProvider() == User.AuthProvider.LOCAL) {
                // Link OAuth account to existing local account
                existingUser.setAuthProvider(provider);
                existingUser.setProviderId(providerId);
                if (existingUser.getFullName() == null || existingUser.getFullName().isEmpty()) {
                    existingUser.setFullName(name);
                }
                if (existingUser.getAvatarUrl() == null || existingUser.getAvatarUrl().isEmpty()) {
                    existingUser.setAvatarUrl(avatarUrl);
                }
                User updatedUser = userService.updateLastLogin(existingUser);
                
                // Create OAuth2 profile for existing local user
                oauth2UserProfileService.createOrUpdateProfile(
                    updatedUser, registrationId, providerId, email,
                    (String) attributes.get("login"), // username for GitHub, null for Google
                    name, avatarUrl, providerProfileUrl,
                    accessToken, null, tokenExpiresAt, attributes
                );
                
                return updatedUser;
            } else {
                // User exists with different OAuth provider - update with new provider info
                existingUser.setAuthProvider(provider);
                existingUser.setProviderId(providerId);
                existingUser.setFullName(name);
                existingUser.setAvatarUrl(avatarUrl);
                User updatedUser = userService.updateLastLogin(existingUser);
                
                // Update OAuth2 profile
                oauth2UserProfileService.createOrUpdateProfile(
                    updatedUser, registrationId, providerId, email,
                    (String) attributes.get("login"), // username for GitHub, null for Google
                    name, avatarUrl, providerProfileUrl,
                    accessToken, null, tokenExpiresAt, attributes
                );
                
                return updatedUser;
            }
        }
        
        // Create new user
        User newUser = userService.createOAuthUser(email, name, avatarUrl, providerId, provider);
        
        // Create OAuth2 profile for new user
        oauth2UserProfileService.createOrUpdateProfile(
            newUser, registrationId, providerId, email,
            (String) attributes.get("login"), // username for GitHub, null for Google
            name, avatarUrl, providerProfileUrl,
            accessToken, null, tokenExpiresAt, attributes
        );
        
        return newUser;
    }
    
    private String getNameAttributeKey(String registrationId) {
        if ("google".equals(registrationId)) {
            return "sub";
        } else if ("github".equals(registrationId)) {
            return "id";
        }
        return "id";
    }
}
