package com.N07.CinemaProject.controller.admin;

import com.N07.CinemaProject.entity.User;
import com.N07.CinemaProject.service.UserService;
import com.N07.CinemaProject.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin/users")
@PreAuthorize("hasRole('ADMIN')")
public class AdminUserController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserService userService;

    @GetMapping
    public String listUsers(Model model) {
        List<User> users = userRepository.findAll();
        model.addAttribute("users", users);
        return "admin/user-management";
    }

    @GetMapping("/add")
    public String addUserForm(Model model) {
        model.addAttribute("user", new User());
        model.addAttribute("roles", User.Role.values());
        return "admin/user-form";
    }

    @PostMapping("/add")
    public String addUser(@RequestParam String username,
                         @RequestParam String email,
                         @RequestParam String password,
                         @RequestParam User.Role role,
                         @RequestParam(required = false, defaultValue = "false") boolean isEnabled,
                         RedirectAttributes redirectAttributes) {
        try {
            // Bảo vệ: Không cho phép tạo tài khoản ADMIN thông qua form
            if (role == User.Role.ADMIN) {
                redirectAttributes.addFlashAttribute("error", "Không thể tạo tài khoản Administrator thông qua form này!");
                return "redirect:/admin/users/add";
            }
            
            if (userService.usernameExists(username)) {
                redirectAttributes.addFlashAttribute("error", "Tên đăng nhập đã tồn tại!");
                return "redirect:/admin/users/add";
            }
            if (userService.emailExists(email)) {
                redirectAttributes.addFlashAttribute("error", "Email đã tồn tại!");
                return "redirect:/admin/users/add";
            }
            
            User user = userService.createUser(username, email, password, role);
            user.setIsEnabled(isEnabled);
            userRepository.save(user);
            redirectAttributes.addFlashAttribute("success", "Đã thêm người dùng thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi khi thêm người dùng: " + e.getMessage());
        }
        return "redirect:/admin/users";
    }

    @PostMapping("/{id}/toggle-status")
    @ResponseBody
    public String toggleUserStatus(@PathVariable Long id) {
        try {
            Optional<User> userOpt = userRepository.findById(id);
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                
                // Bảo vệ tài khoản ADMIN khỏi bị thay đổi trạng thái
                if (userService.isAdministrator(user)) {
                    return "admin_protected";
                }
                
                user.setIsEnabled(!user.getIsEnabled());
                userRepository.save(user);
                return "success";
            }
            return "error";
        } catch (Exception e) {
            return "error";
        }
    }

    @DeleteMapping("/{id}")
    @ResponseBody
    public String deleteUser(@PathVariable Long id) {
        try {
            Optional<User> userOpt = userRepository.findById(id);
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                
                // Bảo vệ tài khoản ADMIN khỏi bị xóa
                if (userService.isAdministrator(user)) {
                    return "admin_protected";
                }
            }
            
            userRepository.deleteById(id);
            return "success";
        } catch (Exception e) {
            return "error";
        }
    }

    @GetMapping("/{id}/edit")
    public String editUserForm(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        try {
            Optional<User> userOpt = userRepository.findById(id);
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                
                // Bảo vệ tài khoản ADMIN khỏi bị chỉnh sửa
                if (userService.isAdministrator(user)) {
                    redirectAttributes.addFlashAttribute("error", "Không thể chỉnh sửa tài khoản Administrator!");
                    return "redirect:/admin/users";
                }
                
                model.addAttribute("user", user);
                model.addAttribute("roles", User.Role.values());
                return "admin/user-edit-form";
            } else {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy người dùng!");
                return "redirect:/admin/users";
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi khi tải thông tin người dùng: " + e.getMessage());
            return "redirect:/admin/users";
        }
    }

    @PostMapping("/{id}/edit")
    public String updateUser(@PathVariable Long id,
                           @RequestParam String username,
                           @RequestParam String email,
                           @RequestParam User.Role role,
                           @RequestParam(required = false, defaultValue = "false") boolean isEnabled,
                           RedirectAttributes redirectAttributes) {
        try {
            Optional<User> userOpt = userRepository.findById(id);
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                
                // Bảo vệ tài khoản ADMIN khỏi bị chỉnh sửa
                if (userService.isAdministrator(user)) {
                    redirectAttributes.addFlashAttribute("error", "Không thể chỉnh sửa tài khoản Administrator!");
                    return "redirect:/admin/users";
                }
                
                // Bảo vệ: Không cho phép thay đổi vai trò thành ADMIN
                if (role == User.Role.ADMIN) {
                    redirectAttributes.addFlashAttribute("error", "Không thể thay đổi vai trò thành Administrator!");
                    return "redirect:/admin/users/" + id + "/edit";
                }
                
                // Check if username is already taken by another user
                if (!user.getUsername().equals(username) && userService.usernameExists(username)) {
                    redirectAttributes.addFlashAttribute("error", "Tên đăng nhập đã tồn tại!");
                    return "redirect:/admin/users/" + id + "/edit";
                }
                
                // Check if email is already taken by another user
                if (!user.getEmail().equals(email) && userService.emailExists(email)) {
                    redirectAttributes.addFlashAttribute("error", "Email đã tồn tại!");
                    return "redirect:/admin/users/" + id + "/edit";
                }
                
                user.setUsername(username);
                user.setEmail(email);
                user.setRole(role);
                user.setIsEnabled(isEnabled);
                userRepository.save(user);
                
                redirectAttributes.addFlashAttribute("success", "Đã cập nhật thông tin người dùng thành công!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy người dùng!");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi khi cập nhật người dùng: " + e.getMessage());
        }
        return "redirect:/admin/users";
    }
}
