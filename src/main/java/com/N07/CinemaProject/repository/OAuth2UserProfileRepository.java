package com.N07.CinemaProject.repository;

import com.N07.CinemaProject.entity.OAuth2UserProfile;
import com.N07.CinemaProject.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface OAuth2UserProfileRepository extends JpaRepository<OAuth2UserProfile, Long> {
    
    Optional<OAuth2UserProfile> findByUser(User user);
    
    Optional<OAuth2UserProfile> findByProviderNameAndProviderUserId(String providerName, String providerUserId);
    
    Optional<OAuth2UserProfile> findByProviderNameAndProviderEmail(String providerName, String providerEmail);
    
    @Query("SELECT o FROM OAuth2UserProfile o WHERE o.user.id = :userId")
    Optional<OAuth2UserProfile> findByUserId(@Param("userId") Long userId);
    
    @Query("SELECT o FROM OAuth2UserProfile o WHERE o.providerName = :providerName AND o.isActive = true")
    List<OAuth2UserProfile> findActiveProfilesByProvider(@Param("providerName") String providerName);
    
    @Query("SELECT o FROM OAuth2UserProfile o WHERE o.lastLogin >= :since ORDER BY o.lastLogin DESC")
    List<OAuth2UserProfile> findRecentLogins(@Param("since") LocalDateTime since);
    
    @Query("SELECT COUNT(o) FROM OAuth2UserProfile o WHERE o.providerName = :providerName AND o.isActive = true")
    Long countActiveUsersByProvider(@Param("providerName") String providerName);
    
    boolean existsByProviderNameAndProviderUserId(String providerName, String providerUserId);
}
