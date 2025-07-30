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
            Booking booking = bookingService.getBookingById(bookingId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy booking"));
            
            // Kiểm tra xem booking đã được thanh toán chưa
            if (booking.getBookingStatus() == Booking.BookingStatus.CONFIRMED) {
                return "redirect:/booking/confirmation/" + bookingId;
            }
            
            model.addAttribute("booking", booking);
            model.addAttribute("paymentMethods", Payment.PaymentMethod.values());
            
            return "pages/payment";
        } catch (Exception e) {
            return "redirect:/movies";
        }
    }
    
    @PostMapping("/process")
    public String processPayment(@RequestParam Long bookingId,
                                @RequestParam String paymentMethod,
                                RedirectAttributes redirectAttributes) {
        try {
            // Tạo payment
            Payment.PaymentMethod method = Payment.PaymentMethod.valueOf(paymentMethod);
            Payment payment = paymentService.createPayment(bookingId, method);
            
            // Giả lập xử lý thanh toán (trong thực tế sẽ tích hợp với gateway thanh toán)
            boolean paymentSuccess = simulatePaymentProcessing(payment);
            
            // Cập nhật trạng thái payment
            payment = paymentService.processPayment(payment.getId(), paymentSuccess);
            
            if (paymentSuccess) {
                redirectAttributes.addFlashAttribute("success", 
                    "Thanh toán thành công! Mã giao dịch: " + payment.getTransactionId());
                return "redirect:/payment/success/" + payment.getId();
            } else {
                redirectAttributes.addFlashAttribute("error", 
                    "Thanh toán thất bại! Vui lòng thử lại.");
                return "redirect:/payment/booking/" + bookingId;
            }
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", 
                "Lỗi xử lý thanh toán: " + e.getMessage());
            return "redirect:/payment/booking/" + bookingId;
        }
    }
    
    @GetMapping("/success/{paymentId}")
    public String paymentSuccess(@PathVariable Long paymentId, Model model) {
        try {
            Payment payment = paymentService.getPaymentById(paymentId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy payment"));
            
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
                .orElseThrow(() -> new RuntimeException("Không tìm thấy payment"));
            
            model.addAttribute("payment", payment);
            model.addAttribute("booking", payment.getBooking());
            
            return "pages/payment-failed";
        } catch (Exception e) {
            return "redirect:/movies";
        }
    }
    
    /**
     * Giả lập quá trình xử lý thanh toán
     * Trong thực tế sẽ tích hợp với các gateway thanh toán như VNPay, MoMo, etc.
     */
    private boolean simulatePaymentProcessing(Payment payment) {
        try {
            // Giả lập delay xử lý
            Thread.sleep(1000);
            
            // Giả lập tỷ lệ thành công 95%
            return Math.random() < 0.95;
        } catch (InterruptedException e) {
            return false;
        }
    }
}
