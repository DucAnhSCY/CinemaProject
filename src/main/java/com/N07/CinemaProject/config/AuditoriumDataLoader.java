package com.N07.CinemaProject.config;

import com.N07.CinemaProject.entity.Theater;
import com.N07.CinemaProject.entity.Auditorium;
import com.N07.CinemaProject.repository.TheaterRepository;
import com.N07.CinemaProject.repository.AuditoriumRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class AuditoriumDataLoader implements CommandLineRunner {
    
    @Autowired
    private TheaterRepository theaterRepository;
    
    @Autowired
    private AuditoriumRepository auditoriumRepository;
    
    @Override
    public void run(String... args) throws Exception {
        // Chỉ tạo dữ liệu nếu chưa có auditoriums
        if (auditoriumRepository.count() == 0) {
            createSampleAuditoriums();
        }
    }
    
    private void createSampleAuditoriums() {
        List<Theater> theaters = theaterRepository.findAll();
        
        for (Theater theater : theaters) {
            // Tạo 3 phòng chiếu cho mỗi rạp
            for (int i = 1; i <= 3; i++) {
                Auditorium auditorium = new Auditorium();
                auditorium.setName("Phòng " + i);
                auditorium.setTheater(theater);
                auditorium.setTotalSeats(120); // 10 rows x 12 seats
                
                auditoriumRepository.save(auditorium);
            }
        }
        
        System.out.println("Created sample auditoriums for " + theaters.size() + " theaters");
    }
}
