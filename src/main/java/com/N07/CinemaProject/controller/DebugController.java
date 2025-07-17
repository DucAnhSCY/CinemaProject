package com.N07.CinemaProject.controller;

import com.N07.CinemaProject.entity.User;
import com.N07.CinemaProject.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/debug")
public class DebugController {

    @Autowired
    private UserService userService;

    @GetMapping("/create-admin")
    @ResponseBody
    public String createAdminUser() {
        try {
            // Check if admin already exists
            var existingAdmin = userService.findByEmail("admin@cinema.com");
            if (existingAdmin.isPresent()) {
                User admin = existingAdmin.get();
                return "Admin user already exists: " + admin.getEmail() + " with role: " + admin.getRole();
            }

            // Create admin user
            User admin = userService.createUser("admin", "admin@cinema.com", "admin123", User.Role.ADMIN);
            return "Admin user created successfully: " + admin.getEmail() + " with role: " + admin.getRole();
        } catch (Exception e) {
            return "Error creating admin user: " + e.getMessage();
        }
    }

    @GetMapping("/list-users")
    @ResponseBody
    public Object listAllUsers() {
        try {
            return userService.findByEmail("admin@cinema.com");
        } catch (Exception e) {
            return "Error listing users: " + e.getMessage();
        }
    }
}
