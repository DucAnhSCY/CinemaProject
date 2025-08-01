package com.N07.CinemaProject.security;

import com.N07.CinemaProject.service.CustomOAuth2User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Slf4j
@Component
public class OAuth2AuthenticationSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                      Authentication authentication) throws IOException, ServletException {
        
        if (authentication.getPrincipal() instanceof CustomOAuth2User) {
            CustomOAuth2User oauth2User = (CustomOAuth2User) authentication.getPrincipal();
            log.info("OAuth2 login successful for user: {} (ID: {})", 
                    oauth2User.getEmail(), oauth2User.getId());
            
            // Set session attributes if needed
            request.getSession().setAttribute("user", oauth2User.getUser());
            request.getSession().setAttribute("userEmail", oauth2User.getEmail());
            request.getSession().setAttribute("userName", oauth2User.getName());
        }
        
        // Redirect to the target URL or default success URL
        String targetUrl = determineTargetUrl(request, response, authentication);
        
        if (response.isCommitted()) {
            log.debug("Response has already been committed. Unable to redirect to " + targetUrl);
            return;
        }
        
        getRedirectStrategy().sendRedirect(request, response, targetUrl);
    }
    
    @Override
    protected String determineTargetUrl(HttpServletRequest request, HttpServletResponse response, 
                                       Authentication authentication) {
        // Check if there's a saved request
        String savedRequest = (String) request.getSession().getAttribute("SPRING_SECURITY_SAVED_REQUEST");
        if (savedRequest != null) {
            request.getSession().removeAttribute("SPRING_SECURITY_SAVED_REQUEST");
            return savedRequest;
        }
        
        // Default redirect URL
        return "/";
    }
}
