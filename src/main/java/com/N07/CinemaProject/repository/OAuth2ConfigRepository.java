package com.N07.CinemaProject.repository;

import com.N07.CinemaProject.entity.OAuth2Config;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface OAuth2ConfigRepository extends JpaRepository<OAuth2Config, Long> {
    
    Optional<OAuth2Config> findByProviderNameIgnoreCase(String providerName);
    
    @Query("SELECT o FROM OAuth2Config o WHERE o.isEnabled = true")
    List<OAuth2Config> findAllEnabled();
    
    @Query("SELECT o FROM OAuth2Config o WHERE o.providerName = :providerName AND o.isEnabled = true")
    Optional<OAuth2Config> findByProviderNameAndEnabled(@Param("providerName") String providerName);
    
    boolean existsByProviderNameIgnoreCase(String providerName);
}
