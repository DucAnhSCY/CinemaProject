package com.N07.CinemaProject.service;

import com.N07.CinemaProject.entity.Booking;
import com.N07.CinemaProject.entity.Payment;
import com.N07.CinemaProject.repository.BookingRepository;
import com.N07.CinemaProject.repository.PaymentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
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
            .orElseThrow(() -> new RuntimeException("Không tìm thấy booking"));
        
        // Kiểm tra xem booking đã có payment chưa
        if (booking.getPayment() != null) {
            throw new RuntimeException("Booking này đã được thanh toán");
        }
        
        Payment payment = new Payment();
        payment.setBooking(booking);
        // Sử dụng chính xác số tiền từ booking để tránh làm tròn
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
            .orElseThrow(() -> new RuntimeException("Không tìm thấy payment"));
        
        if (success) {
            payment.setStatus(Payment.PaymentStatus.COMPLETED);
            // Cập nhật trạng thái booking thành CONFIRMED
            Booking booking = payment.getBooking();
            booking.setBookingStatus(Booking.BookingStatus.CONFIRMED);
            bookingRepository.save(booking);
        } else {
            payment.setStatus(Payment.PaymentStatus.FAILED);
            // Có thể huỷ booking hoặc để lại để retry
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
            .orElseThrow(() -> new RuntimeException("Không tìm thấy payment"));
        
        if (payment.getStatus() != Payment.PaymentStatus.COMPLETED) {
            throw new RuntimeException("Chỉ có thể hoàn tiền cho thanh toán đã hoàn thành");
        }
        
        payment.setStatus(Payment.PaymentStatus.REFUNDED);
        
        // Cập nhật trạng thái booking
        Booking booking = payment.getBooking();
        booking.setBookingStatus(Booking.BookingStatus.CANCELLED);
        bookingRepository.save(booking);
        
        return paymentRepository.save(payment);
    }
}
