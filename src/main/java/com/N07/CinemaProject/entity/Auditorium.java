package com.N07.CinemaProject.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Table(name = "auditoriums")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Auditorium {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "theater_id", nullable = false)
    private Theater theater;
    
    @Column(nullable = false)
    private String name;
    
    @Column(name = "total_seats")
    private Integer totalSeats;
    
    // Thêm các trường mới để mô tả loại phòng chiếu
    @Column(name = "screen_type")
    private String screenType; // 2D, 3D, IMAX, 4DX
    
    @Column(name = "sound_system")
    private String soundSystem; // Dolby Atmos, DTS, THX
    
    @OneToMany(mappedBy = "auditorium", cascade = CascadeType.ALL)
    private List<Seat> seats;
    
    @OneToMany(mappedBy = "auditorium", cascade = CascadeType.ALL)
    private List<Screening> screenings;
}
