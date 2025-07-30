package com.N07.CinemaProject.controller;

import com.N07.CinemaProject.entity.User;
import com.N07.CinemaProject.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/auth")
public class AuthController {
    
    @Autowired
    private UserService userService;
    
    @GetMapping("/login")
    public String loginPage(@RequestParam(value = "error", required = false) String error,
                           @RequestParam(value = "message", required = false) String message,
                           @RequestParam(value = "code", required = false) String code,
                           @RequestParam(value = "logout", required = false) String logout,
                           Model model) {
        if (error != null) {
            if (message != null && !message.trim().isEmpty()) {
                // Sử dụng message cụ thể từ CustomAuthenticationFailureHandler
                model.addAttribute("error", message);
                
                // Thêm error code để có thể xử lý UI khác nhau
                if (code != null) {
                    model.addAttribute("errorCode", code);
                    
                    // Thêm class CSS tương ứng với loại lỗi
                    switch (code) {
                        case "account_disabled":
                        case "account_locked":
                        case "account_status_error":
                            model.addAttribute("errorClass", "alert-warning");
                            break;
                        case "user_not_found":
                        case "wrong_password":
                        case "invalid_credentials":
                            model.addAttribute("errorClass", "alert-danger");
                            break;
                        default:
                            model.addAttribute("errorClass", "alert-danger");
                    }
                }
            } else {
                // Fallback message
                model.addAttribute("error", "Đăng nhập thất bại. Vui lòng thử lại.");
                model.addAttribute("errorClass", "alert-danger");
            }
        }
        
        if (logout != null) {
            model.addAttribute("logout", true);
        }
        
        return "auth/login";
    }
    
    @GetMapping("/register")
    public String registerPage() {
        return "auth/register";
    }
    
    @PostMapping("/register")
    public String registerUser(@RequestParam String username,
                              @RequestParam String email,
                              @RequestParam String password,
                              @RequestParam String confirmPassword,
                              @RequestParam(required = false) String fullName,
                              RedirectAttributes redirectAttributes) {
        try {
            // Validate input
            if (username == null || username.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Tên đăng nhập không được để trống");
                return "redirect:/auth/register";
            }
            
            if (email == null || email.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Email không được để trống");
                return "redirect:/auth/register";
            }
            
            if (password == null || password.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Mật khẩu không được để trống");
                return "redirect:/auth/register";
            }
            
            if (!password.equals(confirmPassword)) {
                redirectAttributes.addFlashAttribute("error", "Mật khẩu xác nhận không khớp");
                return "redirect:/auth/register";
            }
            
            if (password.length() < 6) {
                redirectAttributes.addFlashAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự");
                return "redirect:/auth/register";
            }

            // Check if username or email already exists
            if (userService.usernameExists(username)) {
                redirectAttributes.addFlashAttribute("error", "Tên đăng nhập đã tồn tại");
                return "redirect:/auth/register";
            }
            
            if (userService.emailExists(email)) {
                redirectAttributes.addFlashAttribute("error", "Email đã được sử dụng");
                return "redirect:/auth/register";
            }

            // Create user
            User user = userService.createUser(username, email, password, User.Role.CUSTOMER);
            
            if (fullName != null && !fullName.trim().isEmpty()) {
                user.setFullName(fullName.trim());
            }
            
            redirectAttributes.addFlashAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
            return "redirect:/auth/login";
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return "redirect:/auth/register";
        }
    }
    
    /**
     * API endpoint để lấy thông tin user hiện tại (cho JavaScript)
     */
    @GetMapping("/current-user")
    @ResponseBody
    public Object getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getName())) {
            return null;
        }
        
        // If it's an OAuth2 user
        if (auth.getPrincipal() instanceof com.N07.CinemaProject.security.CustomOAuth2User) {
            com.N07.CinemaProject.security.CustomOAuth2User customUser = 
                (com.N07.CinemaProject.security.CustomOAuth2User) auth.getPrincipal();
            
            return java.util.Map.of(
                "id", customUser.getId(),
                "username", customUser.getUsername() != null ? customUser.getUsername() : "",
                "email", customUser.getEmail() != null ? customUser.getEmail() : "",
                "fullName", customUser.getFullName() != null ? customUser.getFullName() : "",
                "displayName", customUser.getDisplayName(),
                "avatarUrl", customUser.getAvatarUrl() != null ? customUser.getAvatarUrl() : "",
                "role", customUser.getRole().name(),
                "authProvider", customUser.getUser().getAuthProvider().name()
            );
        }
        
        // If it's a regular user, get from database
        java.util.Optional<User> userOpt = userService.getCurrentUser();
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            return java.util.Map.of(
                "id", user.getId(),
                "username", user.getUsername() != null ? user.getUsername() : "",
                "email", user.getEmail() != null ? user.getEmail() : "",
                "fullName", user.getFullName() != null ? user.getFullName() : "",
                "displayName", user.getFullName() != null && !user.getFullName().trim().isEmpty() 
                    ? user.getFullName() : user.getUsername(),
                "avatarUrl", user.getAvatarUrl() != null ? user.getAvatarUrl() : "",
                "role", user.getRole().name(),
                "authProvider", user.getAuthProvider().name()
            );
        }
        
        return null;
    }

    @GetMapping("/check-auth")
    @ResponseBody
    public Object checkAuthentication() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getPrincipal());
    }
    
    @GetMapping("/logout")
    public String logout() {
        // Show logout confirmation page
        return "auth/logout-confirm";
    }
    
    /**
     * Debug page để kiểm tra thông tin người dùng OAuth2
     */
    @GetMapping("/debug")
    public String debugPage() {
        return "auth/debug";
    }
    
    /**
     * Test endpoint để trả về thông tin user đơn giản
     */
    @GetMapping("/user-info")
    @ResponseBody
    public String getUserInfo() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getName())) {
            return "Not authenticated";
        }
        
        if (auth.getPrincipal() instanceof com.N07.CinemaProject.security.CustomOAuth2User) {
            com.N07.CinemaProject.security.CustomOAuth2User customUser = 
                (com.N07.CinemaProject.security.CustomOAuth2User) auth.getPrincipal();
            
            return "CustomOAuth2User - Name: " + customUser.getName() + 
                   ", FullName: " + customUser.getFullName() + 
                   ", Username: " + customUser.getUsername() +
                   ", Email: " + customUser.getEmail();
        }
        
        return "Regular user: " + auth.getName();
    }
}
