package com.N07.CinemaProject.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Entity
@Table(name = "booking_promotions")
@Data
@NoArgsConstructor
@AllArgsConstructor
@IdClass(BookingPromotionId.class)
public class BookingPromotion {
    @Id
    @ManyToOne
    @JoinColumn(name = "booking_id")
    @JsonIgnore
    private Booking booking;
    
    @Id
    @ManyToOne
    @JoinColumn(name = "promotion_id")
    @JsonIgnore
    private Promotion promotion;
    
    @Column(name = "discount_applied", precision = 10, scale = 2)
    private BigDecimal discountApplied;
}
