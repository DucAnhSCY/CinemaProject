package com.N07.CinemaProject.service;

import com.N07.CinemaProject.entity.Theater;
import com.N07.CinemaProject.entity.Auditorium;
import com.N07.CinemaProject.entity.Movie;
import com.N07.CinemaProject.entity.Screening;
import com.N07.CinemaProject.repository.TheaterRepository;
import com.N07.CinemaProject.repository.AuditoriumRepository;
import com.N07.CinemaProject.repository.ScreeningRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Service cho hệ thống 1 rạp chiếu phim duy nhất
 * Đơn giản hóa logic quản lý rạp và cung cấp các phương thức tiện ích
 */
@Service
@Transactional
public class SingleCinemaService {
    
    @Autowired
    private TheaterRepository theaterRepository;
    
    @Autowired
    private AuditoriumRepository auditoriumRepository;
    
    @Autowired
    private ScreeningRepository screeningRepository;
    
    /**
     * Lấy thông tin rạp chiếu phim (luôn là rạp đầu tiên trong DB)
     */
    public Theater getCinema() {
        List<Theater> theaters = theaterRepository.findAll();
        if (theaters.isEmpty()) {
            throw new RuntimeException("Không tìm thấy rạp chiếu phim trong hệ thống");
        }
        return theaters.get(0); // Luôn lấy rạp đầu tiên
    }
    
    /**
     * Lấy ID của rạp chiếu phim
     */
    public Long getCinemaId() {
        return getCinema().getId();
    }
    
    /**
     * Lấy tên rạp chiếu phim
     */
    public String getCinemaName() {
        return getCinema().getName();
    }
    
    /**
     * Lấy tất cả phòng chiếu của rạp
     */
    public List<Auditorium> getAllAuditoriums() {
        return auditoriumRepository.findByTheaterId(getCinemaId());
    }
    
    /**
     * Lấy phòng chiếu theo ID
     */
    public Optional<Auditorium> getAuditoriumById(Long id) {
        return auditoriumRepository.findById(id);
    }
    
    /**
     * Kiểm tra phòng chiếu có thuộc về rạp không
     */
    public boolean isAuditoriumBelongsToOurCinema(Long auditoriumId) {
        Optional<Auditorium> auditorium = auditoriumRepository.findById(auditoriumId);
        return auditorium.isPresent() && auditorium.get().getTheater().getId().equals(getCinemaId());
    }
    
    /**
     * Lấy tất cả suất chiếu của rạp (chỉ những suất chưa diễn ra)
     */
    public List<Screening> getAllScreenings() {
        List<Auditorium> auditoriums = getAllAuditoriums();
        LocalDateTime now = LocalDateTime.now();
        return screeningRepository.findByAuditoriumInOrderByStartTimeAsc(auditoriums)
            .stream()
            .filter(screening -> screening.getStartTime().isAfter(now))
            .toList();
    }
    
    /**
     * Lấy suất chiếu theo thời gian
     */
    public List<Screening> getScreeningsByDateRange(LocalDateTime startTime, LocalDateTime endTime) {
        List<Auditorium> auditoriums = getAllAuditoriums();
        return screeningRepository.findByAuditoriumInAndStartTimeBetweenOrderByStartTimeAsc(
            auditoriums, startTime, endTime);
    }
    
    /**
     * Lấy suất chiếu theo phim (chỉ những suất chưa diễn ra)
     */
    public List<Screening> getScreeningsByMovie(Movie movie) {
        List<Auditorium> auditoriums = getAllAuditoriums();
        LocalDateTime now = LocalDateTime.now();
        return screeningRepository.findByMovieAndAuditoriumInOrderByStartTimeAsc(movie, auditoriums)
            .stream()
            .filter(screening -> screening.getStartTime().isAfter(now))
            .toList();
    }
    
    /**
     * Lấy suất chiếu hôm nay
     */
    public List<Screening> getTodayScreenings() {
        LocalDateTime startOfDay = LocalDateTime.now().toLocalDate().atStartOfDay();
        LocalDateTime endOfDay = startOfDay.plusDays(1).minusNanos(1);
        return getScreeningsByDateRange(startOfDay, endOfDay);
    }
    
    /**
     * Lấy suất chiếu trong tuần này
     */
    public List<Screening> getThisWeekScreenings() {
        LocalDateTime startOfWeek = LocalDateTime.now().toLocalDate().atStartOfDay();
        LocalDateTime endOfWeek = startOfWeek.plusDays(7);
        return getScreeningsByDateRange(startOfWeek, endOfWeek);
    }
    
    /**
     * Kiểm tra xem có phải là hệ thống 1 rạp hay không
     */
    public boolean isSingleCinemaSystem() {
        return theaterRepository.count() == 1;
    }
    
    /**
     * Thống kê cơ bản về rạp
     */
    public CinemaStats getCinemaStats() {
        Theater cinema = getCinema();
        List<Auditorium> auditoriums = getAllAuditoriums();
        
        int totalSeats = auditoriums.stream()
            .mapToInt(a -> a.getTotalSeats() != null ? a.getTotalSeats() : 0)
            .sum();
            
        int totalAuditoriums = auditoriums.size();
        
        return new CinemaStats(
            cinema.getName(),
            totalAuditoriums,
            totalSeats,
            cinema.getAddress(),
            cinema.getPhone(),
            cinema.getEmail()
        );
    }
    
    /**
     * Lấy thông tin chi tiết rạp cho hiển thị
     */
    public CinemaInfo getCinemaInfo() {
        Theater cinema = getCinema();
        List<Auditorium> auditoriums = getAllAuditoriums();
        
        return new CinemaInfo(
            cinema.getId(),
            cinema.getName(),
            cinema.getCity(),
            cinema.getAddress(),
            cinema.getPhone(),
            cinema.getEmail(),
            cinema.getDescription(),
            cinema.getOpeningHours(),
            auditoriums
        );
    }
    
    // DTO classes
    public static class CinemaStats {
        private String name;
        private int totalAuditoriums;
        private int totalSeats;
        private String address;
        private String phone;
        private String email;
        
        public CinemaStats(String name, int totalAuditoriums, int totalSeats, 
                          String address, String phone, String email) {
            this.name = name;
            this.totalAuditoriums = totalAuditoriums;
            this.totalSeats = totalSeats;
            this.address = address;
            this.phone = phone;
            this.email = email;
        }
        
        // Getters
        public String getName() { return name; }
        public int getTotalAuditoriums() { return totalAuditoriums; }
        public int getTotalSeats() { return totalSeats; }
        public String getAddress() { return address; }
        public String getPhone() { return phone; }
        public String getEmail() { return email; }
    }
    
    public static class CinemaInfo {
        private Long id;
        private String name;
        private String city;
        private String address;
        private String phone;
        private String email;
        private String description;
        private String openingHours;
        private List<Auditorium> auditoriums;
        
        public CinemaInfo(Long id, String name, String city, String address, String phone, 
                         String email, String description, String openingHours, 
                         List<Auditorium> auditoriums) {
            this.id = id;
            this.name = name;
            this.city = city;
            this.address = address;
            this.phone = phone;
            this.email = email;
            this.description = description;
            this.openingHours = openingHours;
            this.auditoriums = auditoriums;
        }
        
        // Getters
        public Long getId() { return id; }
        public String getName() { return name; }
        public String getCity() { return city; }
        public String getAddress() { return address; }
        public String getPhone() { return phone; }
        public String getEmail() { return email; }
        public String getDescription() { return description; }
        public String getOpeningHours() { return openingHours; }
        public List<Auditorium> getAuditoriums() { return auditoriums; }
    }
}
