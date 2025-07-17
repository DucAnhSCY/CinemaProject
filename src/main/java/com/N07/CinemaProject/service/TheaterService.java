package com.N07.CinemaProject.service;

import com.N07.CinemaProject.entity.Theater;
import com.N07.CinemaProject.entity.Auditorium;
import com.N07.CinemaProject.repository.TheaterRepository;
import com.N07.CinemaProject.repository.AuditoriumRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class TheaterService {
    
    @Autowired
    private TheaterRepository theaterRepository;
    
    @Autowired
    private AuditoriumRepository auditoriumRepository;
    
    public List<Theater> getAllTheaters() {
        return theaterRepository.findAll();
    }
    
    public Optional<Theater> getTheaterById(Long id) {
        return theaterRepository.findById(id);
    }
    
    public Theater saveTheater(Theater theater) {
        return theaterRepository.save(theater);
    }
    
    public void deleteTheater(Long id) {
        theaterRepository.deleteById(id);
    }
    
    public List<Theater> searchTheatersByName(String name) {
        return theaterRepository.findByNameContainingIgnoreCase(name);
    }
    
    public List<Theater> searchTheatersByAddress(String address) {
        return theaterRepository.findByAddressContainingIgnoreCase(address);
    }
    
    public List<Theater> searchTheatersByCity(String city) {
        return theaterRepository.findByCity(city);
    }
    
    public List<Theater> searchTheaters(String name, String location) {
        if (name != null && location != null) {
            // Try search by address first, then by city
            List<Theater> results = theaterRepository.findByNameContainingIgnoreCaseAndAddressContainingIgnoreCase(name, location);
            if (results.isEmpty()) {
                results = theaterRepository.findByNameContainingIgnoreCaseAndCityContainingIgnoreCase(name, location);
            }
            return results;
        } else if (name != null) {
            return searchTheatersByName(name);
        } else if (location != null) {
            // Try search by address first, then by city  
            List<Theater> results = searchTheatersByAddress(location);
            if (results.isEmpty()) {
                results = searchTheatersByCity(location);
            }
            return results;
        } else {
            return getAllTheaters();
        }
    }
    
    public boolean existsByName(String name) {
        return theaterRepository.existsByName(name);
    }
    
    public boolean existsByNameExcludingId(String name, Long id) {
        return theaterRepository.existsByNameAndIdNot(name, id);
    }
    
    public Optional<Auditorium> getAuditoriumById(Long id) {
        return auditoriumRepository.findById(id);
    }
    
    public List<Auditorium> getAuditoriumsByTheaterId(Long theaterId) {
        return auditoriumRepository.findByTheaterId(theaterId);
    }
}
