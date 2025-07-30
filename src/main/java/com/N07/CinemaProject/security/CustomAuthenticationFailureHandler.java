package com.N07.CinemaProject.security;

import com.N07.CinemaProject.entity.User;
import com.N07.CinemaProject.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.authentication.AccountStatusException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Optional;

@Component
public class CustomAuthenticationFailureHandler implements AuthenticationFailureHandler {

    @Autowired
    @Lazy
    private UserService userService;

    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
                                      AuthenticationException exception) throws IOException, ServletException {
        String username = request.getParameter("username");
        String errorMessage = "Đăng nhập thất bại";
        String errorCode = "unknown";

        // Phân loại lỗi dựa trên exception type
        if (exception instanceof BadCredentialsException) {
            // Kiểm tra xem username có tồn tại không
            if (username != null && !username.trim().isEmpty()) {
                Optional<User> userByUsername = userService.findByUsername(username);
                Optional<User> userByEmail = userService.findByEmail(username);
                
                if (userByUsername.isPresent() || userByEmail.isPresent()) {
                    // User tồn tại nhưng password sai
                    errorMessage = "Mật khẩu không đúng";
                    errorCode = "wrong_password";
                } else {
                    // Username/email không tồn tại
                    errorMessage = "Tên đăng nhập hoặc email không tồn tại";
                    errorCode = "user_not_found";
                }
            } else {
                errorMessage = "Tên đăng nhập hoặc mật khẩu không đúng";
                errorCode = "invalid_credentials";
            }
        } else if (exception instanceof DisabledException) {
            errorMessage = "Tài khoản của bạn đã bị vô hiệu hóa. Vui lòng liên hệ quản trị viên";
            errorCode = "account_disabled";
        } else if (exception instanceof LockedException) {
            errorMessage = "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên";
            errorCode = "account_locked";
        } else if (exception instanceof AccountStatusException) {
            errorMessage = "Tài khoản của bạn có vấn đề. Vui lòng liên hệ quản trị viên";
            errorCode = "account_status_error";
        } else if (exception instanceof UsernameNotFoundException) {
            errorMessage = "Tên đăng nhập hoặc email không tồn tại";
            errorCode = "user_not_found";
        }

        // Encode message để tránh lỗi với ký tự đặc biệt
        String encodedMessage = URLEncoder.encode(errorMessage, StandardCharsets.UTF_8);
        
        // Redirect với error message và error code
        String redirectUrl = "/auth/login?error=true&message=" + encodedMessage + "&code=" + errorCode;
        response.sendRedirect(redirectUrl);
    }
}
