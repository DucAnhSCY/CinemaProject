package com.N07.CinemaProject.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.List;

@Entity
@Table(name = "auditoriums")
@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = {"theater", "screenings", "seats"})
public class Auditorium {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "theater_id", nullable = false)
    @JsonIgnore
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
    @JsonIgnore
    private List<Seat> seats;
    
    @OneToMany(mappedBy = "auditorium", cascade = CascadeType.ALL)
    @JsonIgnore
    private List<Screening> screenings;
}
