package com.N07.CinemaProject.controller;

import com.N07.CinemaProject.entity.OAuth2Config;
import com.N07.CinemaProject.entity.OAuth2UserProfile;
import com.N07.CinemaProject.service.OAuth2ConfigService;
import com.N07.CinemaProject.service.OAuth2UserProfileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/oauth2")
@PreAuthorize("hasRole('ADMIN')")
public class OAuth2AdminController {
    
    @Autowired
    private OAuth2ConfigService oauth2ConfigService;
    
    @Autowired
    private OAuth2UserProfileService oauth2UserProfileService;
    
    @GetMapping("/configs")
    public String configsPage(Model model) {
        List<OAuth2Config> configs = oauth2ConfigService.findAllEnabled();
        model.addAttribute("configs", configs);
        return "admin/oauth2-configs";
    }
    
    @GetMapping("/configs/new")
    public String newConfigPage(Model model) {
        model.addAttribute("config", new OAuth2Config());
        return "admin/oauth2-config-form";
    }
    
    @GetMapping("/configs/edit/{id}")
    public String editConfigPage(@PathVariable Long id, Model model) {
        // Implementation for editing config
        return "admin/oauth2-config-form";
    }
    
    @PostMapping("/configs/save")
    public String saveConfig(@ModelAttribute OAuth2Config config) {
        oauth2ConfigService.save(config);
        return "redirect:/admin/oauth2/configs";
    }
    
    @PostMapping("/configs/toggle/{providerName}")
    @ResponseBody
    public ResponseEntity<?> toggleProvider(@PathVariable String providerName, @RequestParam boolean enabled) {
        if (enabled) {
            oauth2ConfigService.enableProvider(providerName);
        } else {
            oauth2ConfigService.disableProvider(providerName);
        }
        return ResponseEntity.ok().build();
    }
    
    @GetMapping("/users")
    public String usersPage(Model model) {
        // Get statistics for each provider
        Map<String, Long> providerStats = new HashMap<>();
        providerStats.put("google", oauth2UserProfileService.countActiveUsersByProvider("google"));
        providerStats.put("github", oauth2UserProfileService.countActiveUsersByProvider("github"));
        
        // Get recent logins (last 30 days)
        LocalDateTime since = LocalDateTime.now().minusDays(30);
        List<OAuth2UserProfile> recentLogins = oauth2UserProfileService.findRecentLogins(since);
        
        model.addAttribute("providerStats", providerStats);
        model.addAttribute("recentLogins", recentLogins);
        
        return "admin/oauth2-users";
    }
    
    @GetMapping("/api/stats")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getStats() {
        Map<String, Object> stats = new HashMap<>();
        
        // Provider statistics
        Map<String, Long> providerStats = new HashMap<>();
        providerStats.put("google", oauth2UserProfileService.countActiveUsersByProvider("google"));
        providerStats.put("github", oauth2UserProfileService.countActiveUsersByProvider("github"));
        stats.put("providerStats", providerStats);
        
        // Recent activity (last 7 days)
        LocalDateTime since = LocalDateTime.now().minusDays(7);
        List<OAuth2UserProfile> recentLogins = oauth2UserProfileService.findRecentLogins(since);
        stats.put("recentLoginsCount", recentLogins.size());
        
        return ResponseEntity.ok(stats);
    }
}
