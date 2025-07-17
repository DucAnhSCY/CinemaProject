package com.N07.CinemaProject.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "booked_seats", 
       uniqueConstraints = @UniqueConstraint(columnNames = {"seat_id", "screening_id"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookedSeat {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "booking_id", nullable = false)
    private Booking booking;
    
    @ManyToOne
    @JoinColumn(name = "seat_id", nullable = false)
    private Seat seat;
    
    @ManyToOne
    @JoinColumn(name = "screening_id", nullable = false)
    private Screening screening;
}
