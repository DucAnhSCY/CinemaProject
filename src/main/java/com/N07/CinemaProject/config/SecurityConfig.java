package com.N07.CinemaProject.config;

import com.N07.CinemaProject.security.CustomAuthenticationFailureHandler;
import com.N07.CinemaProject.service.CustomOAuth2UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity(prePostEnabled = true)
public class SecurityConfig {
    
    @Autowired
    @Lazy
    private CustomAuthenticationFailureHandler authenticationFailureHandler;
    
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http, CustomOAuth2UserService oAuth2UserService) throws Exception {
        http
            .authorizeHttpRequests(authz -> authz
                // Public endpoints
                .requestMatchers("/", "/home", "/search", "/movies/**", "/api/movies/**", 
                                "/api/tmdb/**", "/css/**", "/js/**", "/images/**", 
                                "/auth/**", "/login", "/register", "/error", "/auth/debug").permitAll()
                
                // Admin-only endpoints (user management, system settings)
                .requestMatchers("/admin/users/**", "/admin/system/**", "/api/admin/users/**", 
                                "/api/admin/system/**").hasRole("ADMIN")
                
                // Admin and Theater Manager shared endpoints (movies, theaters, screenings, bookings)
                .requestMatchers("/admin/**", "/api/admin/**").hasAnyRole("THEATER_MANAGER", "ADMIN")
                
                // Theater Manager and Admin endpoints
                .requestMatchers("/manager/**", "/api/manager/**").hasAnyRole("THEATER_MANAGER", "ADMIN")
                
                // User-specific endpoints (requires authentication)
                .requestMatchers("/booking/**", "/api/booking/**", "/profile/**").authenticated()
                
                // All other requests require authentication
                .anyRequest().authenticated()
            )
            .formLogin(form -> form
                .loginPage("/auth/login")
                .loginProcessingUrl("/auth/login")
                .defaultSuccessUrl("/", true)
                .failureHandler(authenticationFailureHandler)
                .permitAll()
            )
            .oauth2Login(oauth2 -> oauth2
                .loginPage("/auth/login")
                .userInfoEndpoint(userInfo -> userInfo
                    .userService(oAuth2UserService)
                )
                .defaultSuccessUrl("/", true)
                .failureUrl("/auth/login?error=true")
            )
            .logout(logout -> logout
                .logoutUrl("/auth/logout")
                .logoutSuccessUrl("/?logout=true")
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID")
                .permitAll()
            )
            .exceptionHandling(ex -> ex
                .accessDeniedPage("/access-denied")
            )
            .csrf(csrf -> csrf
                .ignoringRequestMatchers("/api/**")
            );
        
        return http.build();
    }
}
