package com.N07.CinemaProject.controller;

import com.N07.CinemaProject.entity.Booking;
import com.N07.CinemaProject.entity.Payment;
import com.N07.CinemaProject.service.BookingService;
import com.N07.CinemaProject.service.PaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/payment")
public class PaymentController {
    
    @Autowired
    private PaymentService paymentService;
    
    @Autowired
    private BookingService bookingService;
    
    @GetMapping("/booking/{bookingId}")
    public String showPaymentPage(@PathVariable Long bookingId, Model model) {
        try {
            System.out.println("🔥 Loading payment page for booking ID: " + bookingId);
            
            Booking booking = bookingService.getBookingById(bookingId)
                .orElseThrow(() -> new RuntimeException("Booking not found"));
            
            System.out.println("✅ Found booking: " + booking.getId());
            
            // Check if booking is already confirmed
            if (booking.getBookingStatus() == Booking.BookingStatus.CONFIRMED) {
                System.out.println("⚠️ Booking already confirmed, redirecting...");
                return "redirect:/booking/confirmation/" + bookingId;
            }
            
            model.addAttribute("booking", booking);
            // Provide all payment methods except CASH
            model.addAttribute("paymentMethods", "available");
            
            System.out.println("✅ Payment page setup complete");
            return "pages/payment";
        } catch (Exception e) {
            System.err.println("❌ Error loading payment page: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/movies";
        }
    }
    
    @PostMapping("/process")
    public String processPayment(@RequestParam Long bookingId,
                                @RequestParam String paymentMethod,
                                RedirectAttributes redirectAttributes) {
        try {
            System.out.println("🔥 Processing payment for booking ID: " + bookingId + " with method: " + paymentMethod);
            
            // Create payment
            Payment.PaymentMethod method = Payment.PaymentMethod.valueOf(paymentMethod);
            Payment payment = paymentService.createPayment(bookingId, method);
            System.out.println("✅ Payment created with ID: " + payment.getId());
            
            // Simulate payment processing (in real implementation, would integrate with payment gateway)
            boolean paymentSuccess = simulatePaymentProcessing(payment);
            
            // Update payment status
            payment = paymentService.processPayment(payment.getId(), paymentSuccess);
            System.out.println("✅ Payment processed, final status: " + payment.getStatus());
            
            if (paymentSuccess) {
                System.out.println("🎉 Payment successful, redirecting to success page");
                redirectAttributes.addFlashAttribute("success", 
                    "Payment successful! Transaction ID: " + payment.getTransactionId());
                return "redirect:/payment/success/" + payment.getId();
            } else {
                System.out.println("❌ Payment failed, redirecting to failed page");
                redirectAttributes.addFlashAttribute("error", 
                    "Payment failed! Please try again.");
                return "redirect:/payment/failed/" + payment.getId();
            }
            
        } catch (Exception e) {
            System.err.println("❌ Payment processing error: " + e.getMessage());
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", 
                "Payment processing error: " + e.getMessage());
            return "redirect:/payment/booking/" + bookingId;
        }
    }
    
    @GetMapping("/success/{paymentId}")
    public String paymentSuccess(@PathVariable Long paymentId, Model model) {
        try {
            Payment payment = paymentService.getPaymentById(paymentId)
                .orElseThrow(() -> new RuntimeException("Payment not found"));
            
            model.addAttribute("payment", payment);
            model.addAttribute("booking", payment.getBooking());
            
            return "pages/payment-success";
        } catch (Exception e) {
            return "redirect:/movies";
        }
    }
    
    @GetMapping("/failed/{paymentId}")
    public String paymentFailed(@PathVariable Long paymentId, Model model) {
        try {
            Payment payment = paymentService.getPaymentById(paymentId)
                .orElseThrow(() -> new RuntimeException("Payment not found"));
            
            model.addAttribute("payment", payment);
            model.addAttribute("booking", payment.getBooking());
            
            return "pages/payment-failed";
        } catch (Exception e) {
            return "redirect:/movies";
        }
    }
    
    /**
     * Simulate payment processing
     * In real implementation, this would integrate with payment gateways like VNPay, MoMo, etc.
     */
    private boolean simulatePaymentProcessing(Payment payment) {
        try {
            System.out.println("🔄 Processing payment with method: " + payment.getPaymentMethod());
            
            // Simulate processing delay
            Thread.sleep(1000);
            
            // If payment method is E_WALLET, always fail for testing
            if (payment.getPaymentMethod() == Payment.PaymentMethod.E_WALLET) {
                System.out.println("💳 E-Wallet payment - simulating failure for testing");
                return false;
            }
            
            // For other payment methods, simulate 95% success rate
            boolean success = Math.random() < 0.95;
            System.out.println("💳 Payment result: " + (success ? "SUCCESS" : "FAILED"));
            return success;
        } catch (InterruptedException e) {
            System.err.println("❌ Payment processing interrupted");
            return false;
        }
    }
}
