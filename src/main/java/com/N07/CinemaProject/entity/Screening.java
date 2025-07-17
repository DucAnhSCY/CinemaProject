package com.N07.CinemaProject.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "screenings")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Screening {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "movie_id", nullable = false)
    private Movie movie;
    
    @ManyToOne
    @JoinColumn(name = "auditorium_id", nullable = false)
    private Auditorium auditorium;
    
    @Column(name = "start_time", nullable = false)
    private LocalDateTime startTime;
    
    @Column(name = "ticket_price", precision = 10, scale = 2)
    private BigDecimal ticketPrice;
    
    @OneToMany(mappedBy = "screening", cascade = CascadeType.ALL)
    private List<Booking> bookings;
    
    @OneToMany(mappedBy = "screening", cascade = CascadeType.ALL)
    private List<BookedSeat> bookedSeats;
}
