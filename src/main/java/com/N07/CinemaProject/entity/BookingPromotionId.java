package com.N07.CinemaProject.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookingPromotionId implements Serializable {
    private Long booking;
    private Long promotion;
}
