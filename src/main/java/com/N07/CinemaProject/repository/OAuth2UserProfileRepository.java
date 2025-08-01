package com.N07.CinemaProject.repository;

import com.N07.CinemaProject.entity.OAuth2UserProfile;
import com.N07.CinemaProject.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface OAuth2UserProfileRepository extends JpaRepository<OAuth2UserProfile, Long> {
    
    /**
     * Find OAuth2 profile by provider and provider ID
     */
    Optional<OAuth2UserProfile> findByProviderAndProviderId(User.AuthProvider provider, String providerId);
    
    /**
     * Find OAuth2 profile by user
     */
    Optional<OAuth2UserProfile> findByUser(User user);
    
    /**
     * Find OAuth2 profile by user ID
     */
    @Query("SELECT p FROM OAuth2UserProfile p WHERE p.user.id = :userId")
    Optional<OAuth2UserProfile> findByUserId(@Param("userId") Long userId);
    
    /**
     * Check if a provider ID exists for a specific provider
     */
    boolean existsByProviderAndProviderId(User.AuthProvider provider, String providerId);
    
    /**
     * Delete OAuth2 profile by user ID
     */
    void deleteByUserId(Long userId);
}
