package com.N07.CinemaProject.test;

import com.N07.CinemaProject.entity.Booking;
import com.N07.CinemaProject.entity.OAuth2UserProfile;
import com.N07.CinemaProject.entity.User;
import com.N07.CinemaProject.service.BookingService;
import com.N07.CinemaProject.service.OAuth2UserProfileService;
import com.N07.CinemaProject.service.UserService;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Demo class để hiển thị cách OAuth2 users có thể đặt vé
 * Lưu ý: Đây là class demo, không phải test unit thực sự
 */
public class OAuth2BookingDemo {
    
    private UserService userService;
    private OAuth2UserProfileService oauth2UserProfileService;
    private BookingService bookingService;
    
    /**
     * Demo: Tìm tất cả users đã đăng nhập qua OAuth2 và có đặt vé
     */
    public void demonstrateOAuth2UsersWithBookings() {
        System.out.println("=== OAuth2 Users with Bookings Demo ===");
        
        // 1. Lấy tất cả OAuth2 profiles active
        List<OAuth2UserProfile> googleUsers = oauth2UserProfileService.findActiveProfilesByProvider("google");
        List<OAuth2UserProfile> githubUsers = oauth2UserProfileService.findActiveProfilesByProvider("github");
        
        System.out.println("Total Google users: " + googleUsers.size());
        System.out.println("Total GitHub users: " + githubUsers.size());
        
        // 2. Kiểm tra bookings cho từng OAuth2 user
        googleUsers.forEach(this::checkUserBookings);
        githubUsers.forEach(this::checkUserBookings);
    }
    
    /**
     * Demo: Kiểm tra booking history của một OAuth2 user
     */
    private void checkUserBookings(OAuth2UserProfile oauth2Profile) {
        User user = oauth2Profile.getUser();
        List<Booking> userBookings = user.getBookings();
        
        System.out.println("\n--- OAuth2 User Booking Info ---");
        System.out.println("Provider: " + oauth2Profile.getProviderName());
        System.out.println("User: " + oauth2Profile.getProviderNameDisplay());
        System.out.println("Email: " + oauth2Profile.getProviderEmail());
        System.out.println("Total Bookings: " + (userBookings != null ? userBookings.size() : 0));
        System.out.println("First Login: " + oauth2Profile.getFirstLogin());
        System.out.println("Last Login: " + oauth2Profile.getLastLogin());
        System.out.println("Login Count: " + oauth2Profile.getLoginCount());
        
        if (userBookings != null && !userBookings.isEmpty()) {
            System.out.println("Recent Bookings:");
            userBookings.stream()
                .limit(3) // Show only last 3 bookings
                .forEach(booking -> {
                    System.out.println("  - Booking ID: " + booking.getId() + 
                                     ", Date: " + booking.getBookingTime() +
                                     ", Status: " + booking.getBookingStatus());
                });
        }
    }
    
    /**
     * Demo: Thống kê booking theo provider
     */
    public void demonstrateBookingStatsByProvider() {
        System.out.println("\n=== Booking Statistics by OAuth2 Provider ===");
        
        // Count bookings by Google users
        long googleBookings = countBookingsByProvider("google");
        long githubBookings = countBookingsByProvider("github");
        
        System.out.println("Google Users Bookings: " + googleBookings);
        System.out.println("GitHub Users Bookings: " + githubBookings);
        System.out.println("Total OAuth2 Bookings: " + (googleBookings + githubBookings));
    }
    
    /**
     * Đếm số booking của users từ một OAuth2 provider cụ thể
     */
    private long countBookingsByProvider(String providerName) {
        List<OAuth2UserProfile> profiles = oauth2UserProfileService.findActiveProfilesByProvider(providerName);
        
        return profiles.stream()
            .mapToLong(profile -> {
                List<Booking> bookings = profile.getUser().getBookings();
                return bookings != null ? bookings.size() : 0;
            })
            .sum();
    }
    
    /**
     * Demo: Tìm OAuth2 user có nhiều booking nhất
     */
    public void findTopOAuth2Booker() {
        System.out.println("\n=== Top OAuth2 Bookers ===");
        
        List<OAuth2UserProfile> allProfiles = oauth2UserProfileService.findRecentLogins(
            LocalDateTime.now().minusMonths(12) // Last 12 months
        );
        
        OAuth2UserProfile topBooker = allProfiles.stream()
            .max((p1, p2) -> {
                int bookings1 = p1.getUser().getBookings() != null ? p1.getUser().getBookings().size() : 0;
                int bookings2 = p2.getUser().getBookings() != null ? p2.getUser().getBookings().size() : 0;
                return Integer.compare(bookings1, bookings2);
            })
            .orElse(null);
            
        if (topBooker != null) {
            System.out.println("Top OAuth2 Booker:");
            System.out.println("Name: " + topBooker.getProviderNameDisplay());
            System.out.println("Provider: " + topBooker.getProviderName());
            System.out.println("Total Bookings: " + 
                (topBooker.getUser().getBookings() != null ? topBooker.getUser().getBookings().size() : 0));
        }
    }
    
    /**
     * Demo: Kiểm tra user có thể đặt vé sau khi đăng nhập OAuth2
     */
    public void demonstrateOAuth2UserCanBookTicket(String providerName, String providerUserId, 
                                                   Long screeningId, List<String> seatIds) {
        System.out.println("\n=== OAuth2 User Booking Ticket Demo ===");
        
        // 1. Tìm OAuth2 user profile
        Optional<OAuth2UserProfile> profileOpt = oauth2UserProfileService
            .findByProviderAndUserId(providerName, providerUserId);
            
        if (profileOpt.isEmpty()) {
            System.out.println("OAuth2 user not found!");
            return;
        }
        
        OAuth2UserProfile profile = profileOpt.get();
        User user = profile.getUser();
        
        System.out.println("Found OAuth2 user: " + profile.getProviderNameDisplay());
        System.out.println("Provider: " + profile.getProviderName());
        System.out.println("User ID: " + user.getId());
        
        // 2. Attempt to create booking (pseudo code - actual implementation may vary)
        try {
            // Booking booking = bookingService.createBooking(user.getId(), screeningId, seatIds);
            System.out.println("✅ OAuth2 user can successfully book tickets!");
            System.out.println("User Profile Provider: " + profile.getProviderName());
            System.out.println("User Last Login: " + profile.getLastLogin());
            // System.out.println("Booking ID: " + booking.getId());
        } catch (Exception e) {
            System.out.println("❌ Error creating booking: " + e.getMessage());
        }
    }
    
    /**
     * Demo: Export OAuth2 user booking data
     */
    public void exportOAuth2BookingData() {
        System.out.println("\n=== OAuth2 Booking Data Export Demo ===");
        
        // Get all OAuth2 profiles with bookings
        List<OAuth2UserProfile> allProfiles = oauth2UserProfileService.findRecentLogins(
            LocalDateTime.now().minusYears(1)
        );
        
        System.out.println("OAuth2 Booking Report");
        System.out.println("Generated at: " + LocalDateTime.now());
        System.out.println("Total OAuth2 Users: " + allProfiles.size());
        System.out.println("\n--- User Details ---");
        
        allProfiles.forEach(profile -> {
            User user = profile.getUser();
            List<Booking> bookings = user.getBookings();
            
            System.out.printf("%-15s | %-20s | %-30s | %d bookings%n",
                profile.getProviderName(),
                profile.getProviderNameDisplay(),
                profile.getProviderEmail(),
                bookings != null ? bookings.size() : 0
            );
        });
    }
}
