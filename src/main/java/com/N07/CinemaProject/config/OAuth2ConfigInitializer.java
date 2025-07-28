package com.N07.CinemaProject.config;

import com.N07.CinemaProject.service.OAuth2ConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class OAuth2ConfigInitializer implements CommandLineRunner {
    
    @Autowired
    private OAuth2ConfigService oauth2ConfigService;
    
    @Value("${spring.security.oauth2.client.registration.google.client-id:}")
    private String googleClientId;
    
    @Value("${spring.security.oauth2.client.registration.google.client-secret:}")
    private String googleClientSecret;
    
    @Value("${spring.security.oauth2.client.registration.github.client-id:}")
    private String githubClientId;
    
    @Value("${spring.security.oauth2.client.registration.github.client-secret:}")
    private String githubClientSecret;
    
    @Override
    public void run(String... args) throws Exception {
        // Initialize OAuth2 configurations from application.properties
        initializeOAuth2Configs();
    }
    
    private void initializeOAuth2Configs() {
        // Initialize Google OAuth2 config
        if (!googleClientId.isEmpty() && !googleClientSecret.isEmpty()) {
            oauth2ConfigService.createOrUpdate(
                "google",
                googleClientId,
                googleClientSecret,
                "https://accounts.google.com/o/oauth2/auth",
                "https://oauth2.googleapis.com/token",
                "https://www.googleapis.com/oauth2/v2/userinfo",
                "http://localhost:8080/login/oauth2/code/google",
                "openid,profile,email"
            );
            System.out.println("Google OAuth2 configuration initialized");
        }
        
        // Initialize GitHub OAuth2 config
        if (!githubClientId.isEmpty() && !githubClientSecret.isEmpty()) {
            oauth2ConfigService.createOrUpdate(
                "github",
                githubClientId,
                githubClientSecret,
                "https://github.com/login/oauth/authorize",
                "https://github.com/login/oauth/access_token",
                "https://api.github.com/user",
                "http://localhost:8080/login/oauth2/code/github",
                "user:email"
            );
            System.out.println("GitHub OAuth2 configuration initialized");
        }
    }
}
