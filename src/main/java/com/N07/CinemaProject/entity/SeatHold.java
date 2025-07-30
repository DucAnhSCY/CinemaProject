package com.N07.CinemaProject.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "seat_holds", 
       uniqueConstraints = @UniqueConstraint(columnNames = {"seat_id", "screening_id"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SeatHold {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "seat_id", nullable = false)
    private Seat seat;
    
    @ManyToOne
    @JoinColumn(name = "screening_id", nullable = false)
    private Screening screening;
    
    @Column(name = "user_session", nullable = false)
    private String userSession;
    
    @Column(name = "hold_time", nullable = false)
    private LocalDateTime holdTime;
    
    @Column(name = "expires_at", nullable = false)
    private LocalDateTime expiresAt;
    
    public boolean isExpired() {
        return LocalDateTime.now().isAfter(expiresAt);
    }
}
