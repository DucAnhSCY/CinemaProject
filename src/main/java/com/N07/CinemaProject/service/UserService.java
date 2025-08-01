package com.N07.CinemaProject.service;

import com.N07.CinemaProject.entity.User;
import com.N07.CinemaProject.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Optional;

@Service
public class UserService implements UserDetailsService {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(username)
                .orElseGet(() -> userRepository.findByEmail(username)
                        .orElseThrow(() -> new UsernameNotFoundException("User not found: " + username)));
        
        return org.springframework.security.core.userdetails.User.builder()
                .username(user.getUsername())
                .password(user.getPasswordHash())
                .authorities("ROLE_" + user.getRole().name())
                .accountExpired(false)
                .accountLocked(!user.getIsEnabled())
                .credentialsExpired(false)
                .disabled(!user.getIsEnabled())
                .build();
    }
    
    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }
    
    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }
    
    public Optional<User> findByProviderId(String providerId, User.AuthProvider provider) {
        return userRepository.findByProviderIdAndAuthProvider(providerId, provider);
    }
    
    @Transactional
    public User createUser(String username, String email, String password, User.Role role) {
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPasswordHash(passwordEncoder.encode(password));
        user.setRole(role);
        user.setAuthProvider(User.AuthProvider.LOCAL);
        user.setIsEnabled(true);
        
        return userRepository.save(user);
    }
    
    @Transactional
    public User createOAuthUser(String email, String fullName, String avatarUrl, 
                               String providerId, User.AuthProvider provider) {
        User user = new User();
        
        // Create unique username from email and timestamp to avoid conflicts
        String baseUsername = email.split("@")[0];
        String username = generateUniqueUsername(baseUsername);
        
        user.setUsername(username);
        user.setEmail(email);
        // Đảm bảo fullName được lưu đúng cách
        user.setFullName(fullName != null && !fullName.trim().isEmpty() ? fullName.trim() : baseUsername);
        user.setAvatarUrl(avatarUrl);
        user.setRole(User.Role.CUSTOMER);
        user.setAuthProvider(provider);
        user.setProviderId(providerId);
        user.setIsEnabled(true);
        user.setCreatedAt(LocalDateTime.now());
        user.setLastLogin(LocalDateTime.now());
        // OAuth users don't need password
        
        User savedUser = userRepository.save(user);
        System.out.println("Created OAuth user: " + savedUser.getUsername() + " - " + savedUser.getFullName() + " (" + savedUser.getEmail() + ")");
        return savedUser;
    }
    
    private String generateUniqueUsername(String baseUsername) {
        String username = baseUsername;
        int counter = 1;
        
        while (userRepository.findByUsername(username).isPresent()) {
            username = baseUsername + counter;
            counter++;
        }
        
        return username;
    }
    
    @Transactional
    public User updateLastLogin(User user) {
        user.setLastLogin(LocalDateTime.now());
        return userRepository.save(user);
    }
    
    @Transactional
    public User updateOAuthUser(User existingUser, String fullName, String avatarUrl) {
        if (fullName != null && !fullName.trim().isEmpty()) {
            existingUser.setFullName(fullName.trim());
        }
        if (avatarUrl != null && !avatarUrl.trim().isEmpty()) {
            existingUser.setAvatarUrl(avatarUrl.trim());
        }
        existingUser.setLastLogin(LocalDateTime.now());
        
        User updatedUser = userRepository.save(existingUser);
        System.out.println("Updated OAuth user: " + updatedUser.getUsername() + " - " + updatedUser.getFullName() + " (" + updatedUser.getEmail() + ")");
        return updatedUser;
    }
    
    public boolean emailExists(String email) {
        return userRepository.findByEmail(email).isPresent();
    }
    
    public boolean usernameExists(String username) {
        return userRepository.findByUsername(username).isPresent();
    }
    
    /**
     * Check if a user is an administrator
     */
    public boolean isAdministrator(User user) {
        return user != null && user.getRole() == User.Role.ADMIN;
    }
    
    /**
     * Check if a user by ID is an administrator
     */
    public boolean isAdministrator(Long userId) {
        return userRepository.findById(userId)
                .map(this::isAdministrator)
                .orElse(false);
    }
    
    /**
     * Get current logged in user from Security Context
     */
    public Optional<User> getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getName())) {
            return Optional.empty();
        }
        
        // If it's an OAuth2 user
        if (auth.getPrincipal() instanceof CustomOAuth2User) {
            CustomOAuth2User customUser = (CustomOAuth2User) auth.getPrincipal();
            return Optional.of(customUser.getUser());
        }
        
        // If it's a regular user
        String username = auth.getName();
        return findByUsername(username).or(() -> findByEmail(username));
    }
}
