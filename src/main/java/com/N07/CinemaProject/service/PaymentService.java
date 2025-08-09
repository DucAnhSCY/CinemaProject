package com.N07.CinemaProject.service;

import com.N07.CinemaProject.entity.Booking;
import com.N07.CinemaProject.entity.Payment;
import com.N07.CinemaProject.repository.BookingRepository;
import com.N07.CinemaProject.repository.PaymentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

@Service
public class PaymentService {
    
    @Autowired
    private PaymentRepository paymentRepository;
    
    @Autowired
    private BookingRepository bookingRepository;
    
    @Autowired
    private BookingService bookingService;
    
    @Transactional
    public Payment createPayment(Long bookingId, Payment.PaymentMethod paymentMethod) {
        Booking booking = bookingRepository.findById(bookingId)
            .orElseThrow(() -> new RuntimeException("Booking not found"));
        
        // Check if booking already has payment
        if (booking.getPayment() != null) {
            throw new RuntimeException("This booking has already been paid for");
        }
        
        Payment payment = new Payment();
        payment.setBooking(booking);
        // Use exact amount from booking to avoid rounding issues
        payment.setAmount(booking.getTotalAmount());
        payment.setPaymentMethod(paymentMethod);
        payment.setStatus(Payment.PaymentStatus.PENDING);
        payment.setTransactionId(generateTransactionId());
        payment.setPaymentTime(LocalDateTime.now());
        
        return paymentRepository.save(payment);
    }
    
    @Transactional
    public Payment processPayment(Long paymentId, boolean success) {
        Payment payment = paymentRepository.findById(paymentId)
            .orElseThrow(() -> new RuntimeException("Payment not found"));
        
        if (success) {
            payment.setStatus(Payment.PaymentStatus.COMPLETED);
            // Update booking status to CONFIRMED
            Booking booking = payment.getBooking();
            booking.setBookingStatus(Booking.BookingStatus.CONFIRMED);
            bookingRepository.save(booking);
        } else {
            payment.setStatus(Payment.PaymentStatus.FAILED);
            // Cancel booking and release seats when payment fails
            bookingService.cancelBooking(payment.getBooking().getId());
        }
        
        return paymentRepository.save(payment);
    }
    
    public Optional<Payment> getPaymentById(Long id) {
        return paymentRepository.findById(id);
    }
    
    public Optional<Payment> getPaymentByBookingId(Long bookingId) {
        return paymentRepository.findByBookingId(bookingId);
    }
    
    private String generateTransactionId() {
        return "TXN_" + UUID.randomUUID().toString().replace("-", "").substring(0, 12).toUpperCase();
    }
    
    @Transactional
    public Payment refundPayment(Long paymentId) {
        Payment payment = paymentRepository.findById(paymentId)
            .orElseThrow(() -> new RuntimeException("Payment not found"));
        
        if (payment.getStatus() != Payment.PaymentStatus.COMPLETED) {
            throw new RuntimeException("Can only refund completed payments");
        }
        
        payment.setStatus(Payment.PaymentStatus.REFUNDED);
        
        // Update booking status
        Booking booking = payment.getBooking();
        booking.setBookingStatus(Booking.BookingStatus.CANCELLED);
        bookingRepository.save(booking);
        
        return paymentRepository.save(payment);
    }
}
