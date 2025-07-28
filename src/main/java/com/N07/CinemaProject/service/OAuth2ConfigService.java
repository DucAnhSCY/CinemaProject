package com.N07.CinemaProject.service;

import com.N07.CinemaProject.entity.OAuth2Config;
import com.N07.CinemaProject.repository.OAuth2ConfigRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class OAuth2ConfigService {
    
    @Autowired
    private OAuth2ConfigRepository oauth2ConfigRepository;
    
    public List<OAuth2Config> findAllEnabled() {
        return oauth2ConfigRepository.findAllEnabled();
    }
    
    public Optional<OAuth2Config> findByProviderName(String providerName) {
        return oauth2ConfigRepository.findByProviderNameIgnoreCase(providerName);
    }
    
    public Optional<OAuth2Config> findEnabledByProviderName(String providerName) {
        return oauth2ConfigRepository.findByProviderNameAndEnabled(providerName);
    }
    
    public OAuth2Config save(OAuth2Config config) {
        return oauth2ConfigRepository.save(config);
    }
    
    public OAuth2Config createOrUpdate(String providerName, String clientId, String clientSecret, 
                                     String authorizationUri, String tokenUri, String userInfoUri,
                                     String redirectUri, String scope) {
        OAuth2Config config = oauth2ConfigRepository.findByProviderNameIgnoreCase(providerName)
                .orElse(new OAuth2Config());
        
        config.setProviderName(providerName.toLowerCase());
        config.setClientId(clientId);
        config.setClientSecret(clientSecret);
        config.setAuthorizationUri(authorizationUri);
        config.setTokenUri(tokenUri);
        config.setUserInfoUri(userInfoUri);
        config.setRedirectUri(redirectUri);
        config.setScope(scope);
        config.setIsEnabled(true);
        
        return oauth2ConfigRepository.save(config);
    }
    
    public void enableProvider(String providerName) {
        oauth2ConfigRepository.findByProviderNameIgnoreCase(providerName)
                .ifPresent(config -> {
                    config.setIsEnabled(true);
                    oauth2ConfigRepository.save(config);
                });
    }
    
    public void disableProvider(String providerName) {
        oauth2ConfigRepository.findByProviderNameIgnoreCase(providerName)
                .ifPresent(config -> {
                    config.setIsEnabled(false);
                    oauth2ConfigRepository.save(config);
                });
    }
    
    public void delete(String providerName) {
        oauth2ConfigRepository.findByProviderNameIgnoreCase(providerName)
                .ifPresent(oauth2ConfigRepository::delete);
    }
    
    public boolean exists(String providerName) {
        return oauth2ConfigRepository.existsByProviderNameIgnoreCase(providerName);
    }
    
    /**
     * Initialize default OAuth2 configurations from application.properties
     */
    public void initializeDefaultConfigs() {
        // Google OAuth2 config
        if (!exists("google")) {
            OAuth2Config googleConfig = new OAuth2Config();
            googleConfig.setProviderName("google");
            googleConfig.setAuthorizationUri("https://accounts.google.com/o/oauth2/auth");
            googleConfig.setTokenUri("https://oauth2.googleapis.com/token");
            googleConfig.setUserInfoUri("https://www.googleapis.com/oauth2/v2/userinfo");
            googleConfig.setScope("openid,profile,email");
            googleConfig.setIsEnabled(true);
            oauth2ConfigRepository.save(googleConfig);
        }
        
        // GitHub OAuth2 config
        if (!exists("github")) {
            OAuth2Config githubConfig = new OAuth2Config();
            githubConfig.setProviderName("github");
            githubConfig.setAuthorizationUri("https://github.com/login/oauth/authorize");
            githubConfig.setTokenUri("https://github.com/login/oauth/access_token");
            githubConfig.setUserInfoUri("https://api.github.com/user");
            githubConfig.setScope("user:email");
            githubConfig.setIsEnabled(true);
            oauth2ConfigRepository.save(githubConfig);
        }
    }
}
