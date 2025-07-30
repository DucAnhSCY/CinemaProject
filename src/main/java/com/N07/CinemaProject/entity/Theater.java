package com.N07.CinemaProject.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import com.fasterxml.jackson.annotation.JsonIgnore;

import java.util.List;

@Entity
@Table(name = "theaters")
@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = {"auditoriums"})
public class Theater {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String name;
    
    private String city;
    
    private String address;
    
    // Thêm các trường mới cho thông tin chi tiết rạp
    private String phone;
    
    private String email;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    @Column(name = "opening_hours")
    private String openingHours;
    
    @OneToMany(mappedBy = "theater", cascade = CascadeType.ALL)
    @JsonIgnore
    private List<Auditorium> auditoriums;
}
