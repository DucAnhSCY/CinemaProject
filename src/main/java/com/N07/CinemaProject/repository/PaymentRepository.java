package com.N07.CinemaProject.repository;

import com.N07.CinemaProject.entity.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {
    Optional<Payment> findByBookingId(Long bookingId);
    List<Payment> findByStatus(Payment.PaymentStatus status);
    Optional<Payment> findByTransactionId(String transactionId);
}
