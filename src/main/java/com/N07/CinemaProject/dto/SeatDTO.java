package com.N07.CinemaProject.dto;

import com.N07.CinemaProject.entity.Seat;

public class SeatDTO {
    private Long id;
    private String rowNumber;
    private Integer seatPosition;
    private String seatType;
    private boolean isBooked;
    
    public SeatDTO() {}
    
    public SeatDTO(Long id, String rowNumber, Integer seatPosition, Seat.SeatType seatType, boolean isBooked) {
        this.id = id;
        this.rowNumber = rowNumber;
        this.seatPosition = seatPosition;
        this.seatType = seatType.name();
        this.isBooked = isBooked;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getRowNumber() {
        return rowNumber;
    }
    
    public void setRowNumber(String rowNumber) {
        this.rowNumber = rowNumber;
    }
    
    public Integer getSeatPosition() {
        return seatPosition;
    }
    
    public void setSeatPosition(Integer seatPosition) {
        this.seatPosition = seatPosition;
    }
    
    public String getSeatType() {
        return seatType;
    }
    
    public void setSeatType(String seatType) {
        this.seatType = seatType;
    }
    
    public boolean isBooked() {
        return isBooked;
    }
    
    public void setBooked(boolean booked) {
        isBooked = booked;
    }
}
