package com.N07.CinemaProject.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.hibernate.annotations.BatchSize;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "screenings")
@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = {"movie", "auditorium", "bookings", "bookedSeats"})
public class Screening {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "movie_id", nullable = false)
    @JsonIgnore
    private Movie movie;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "auditorium_id", nullable = false)
    @JsonIgnore
    private Auditorium auditorium;
    
    @Column(name = "start_time", nullable = false)
    private LocalDateTime startTime;
    
    @Column(name = "ticket_price", precision = 10, scale = 2)
    private BigDecimal ticketPrice;
    
    @OneToMany(mappedBy = "screening", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonIgnore
    @BatchSize(size = 10)
    private List<Booking> bookings;
    
    @OneToMany(mappedBy = "screening", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonIgnore
    @BatchSize(size = 20)
    private List<BookedSeat> bookedSeats;
}
