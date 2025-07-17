package com.N07.CinemaProject.repository;

import com.N07.CinemaProject.entity.Theater;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TheaterRepository extends JpaRepository<Theater, Long> {
    
    List<Theater> findByCity(String city);
    
    List<Theater> findByNameContainingIgnoreCase(String name);
    
    List<Theater> findByAddressContainingIgnoreCase(String address);
    
    List<Theater> findByNameContainingIgnoreCaseAndAddressContainingIgnoreCase(String name, String address);
    
    List<Theater> findByNameContainingIgnoreCaseAndCityContainingIgnoreCase(String name, String city);
    
    boolean existsByName(String name);
    
    boolean existsByNameAndIdNot(String name, Long id);
}
