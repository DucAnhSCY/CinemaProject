package com.N07.CinemaProject.controller;

import com.N07.CinemaProject.entity.User;
import com.N07.CinemaProject.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.oauth2.core.user.OAuth2User;
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
                           @RequestParam(value = "logout", required = false) String logout,
                           Model model) {
        if (error != null) {
            model.addAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng!");
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
    
    @GetMapping("/current-user")
    @ResponseBody
    public Object getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getPrincipal())) {
            Object principal = auth.getPrincipal();
            
            if (principal instanceof UserDetails) {
                UserDetails userDetails = (UserDetails) principal;
                return userService.findByUsername(userDetails.getUsername()).orElse(null);
            } else if (principal instanceof OAuth2User) {
                OAuth2User oauth2User = (OAuth2User) principal;
                String email = oauth2User.getAttribute("email");
                return userService.findByEmail(email).orElse(null);
            }
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
}
