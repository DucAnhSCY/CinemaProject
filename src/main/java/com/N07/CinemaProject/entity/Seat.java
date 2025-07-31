package com.N07.CinemaProject.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
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
    @JsonIgnore
    private Auditorium auditorium;
    
    @Column(name = "row_number")
    private String rowNumber;
    
    @Column(name = "seat_position")
    private Integer seatPosition;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "seat_type")
    private SeatType seatType;
    
    // Thêm hệ số nhân giá cho từng loại ghế
    @Column(name = "price_modifier", precision = 5, scale = 2)
    private BigDecimal priceModifier = BigDecimal.ONE; // Default = 1.0
    
    @OneToMany(mappedBy = "seat", cascade = CascadeType.ALL)
    @JsonIgnore
    private List<BookedSeat> bookedSeats;
    
    public enum SeatType {
        STANDARD, VIP, COUPLE
    }
    
    // Method to generate seat name
    public String getName() {
        return rowNumber + seatPosition;
    }
    
    // Method to get price multiplier based on seat type
    public BigDecimal getPriceMultiplier() {
        if (priceModifier != null) {
            return priceModifier;
        }
        
        // Default multipliers based on seat type
        switch (seatType) {
            case VIP:
                return new BigDecimal("1.20"); // Ghế VIP x1.2
            case COUPLE:
                return new BigDecimal("1.70"); // Ghế Couple x1.7
            case STANDARD:
            default:
                return BigDecimal.ONE; // Ghế thường x1.0
        }
    }
    
    // Method to calculate actual price for this seat
    public BigDecimal calculatePrice(BigDecimal basePrice) {
        return basePrice.multiply(getPriceMultiplier());
    }
}
