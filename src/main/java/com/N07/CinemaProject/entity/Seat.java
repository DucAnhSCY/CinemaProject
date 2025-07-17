package com.N07.CinemaProject.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Table(name = "seats")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Seat {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "auditorium_id", nullable = false)
    private Auditorium auditorium;
    
    @Column(name = "row_number")
    private String rowNumber;
    
    @Column(name = "seat_position")
    private Integer seatPosition;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "seat_type")
    private SeatType seatType;
    
    @OneToMany(mappedBy = "seat", cascade = CascadeType.ALL)
    private List<BookedSeat> bookedSeats;
    
    public enum SeatType {
        STANDARD, VIP, COUPLE
    }
}
