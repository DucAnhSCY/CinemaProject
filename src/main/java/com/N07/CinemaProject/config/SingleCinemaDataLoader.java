package com.N07.CinemaProject.config;

import com.N07.CinemaProject.entity.*;
import com.N07.CinemaProject.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Khởi tạo dữ liệu mẫu cho hệ thống 1 rạp duy nhất với 4 phòng chiếu, mỗi phòng 50 ghế
 */
@Component
@Order(2) // Chạy sau các CommandLineRunner khác
@Transactional
public class SingleCinemaDataLoader implements CommandLineRunner {
    
    @Autowired
    private TheaterRepository theaterRepository;
    
    @Autowired
    private AuditoriumRepository auditoriumRepository;
    
    @Autowired
    private SeatRepository seatRepository;
    
    @Autowired
    private MovieRepository movieRepository;
    
    @Autowired
    private ScreeningRepository screeningRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private BookingRepository bookingRepository;
    
    @Autowired
    private BookedSeatRepository bookedSeatRepository;
    
    @Override
    public void run(String... args) throws Exception {
        System.out.println("🎬 Initializing single cinema system with 4 auditoriums...");
        
        // Kiểm tra và làm sạch dữ liệu cũ nếu cần
        cleanupExistingData();
        
        // Tạo hệ thống mới
        createSingleCinema();
        createSampleMovies();
        createSampleScreenings();
        createAdminUser();
        
        System.out.println("✅ Single cinema system initialized successfully!");
        System.out.println("📋 System summary:");
        System.out.println("   - 1 Theater: Cinema Paradise");
        System.out.println("   - 4 Auditoriums: 50 seats each");
        System.out.println("   - Seat types: VIP (20), Standard (21), Couple (9)");
        System.out.println("   - Admin login: admin/password");
    }
    
    private void cleanupExistingData() {
        // Xóa theo thứ tự để tránh constraint violations
        try {
            // Xóa BookedSeats trước
            bookedSeatRepository.deleteAll();
            System.out.println("🧹 Deleted booked seats");
            
            // Xóa Bookings 
            bookingRepository.deleteAll();
            System.out.println("🧹 Deleted bookings");
            
            // Xóa Screenings
            screeningRepository.deleteAll();
            System.out.println("🧹 Deleted screenings");
            
            // Xóa Seats
            seatRepository.deleteAll();
            System.out.println("🧹 Deleted seats");
            
            // Xóa Auditoriums
            auditoriumRepository.deleteAll();
            System.out.println("🧹 Deleted auditoriums");
            
            // Xóa Theaters cuối cùng
            theaterRepository.deleteAll();
            System.out.println("🧹 Deleted theaters");
            
        } catch (Exception e) {
            System.out.println("⚠️ Error during cleanup (might be expected on first run): " + e.getMessage());
        }
        
        System.out.println("🧹 Cleaned up existing data");
    }
    
    private void createSingleCinema() {
        // Tạo rạp chiếu phim duy nhất
        Theater cinema = new Theater();
        cinema.setName("Cinema Paradise");
        cinema.setCity("Đà Nẵng");
        cinema.setAddress("123 Lê Duẩn, Quận Hải Châu, Đà Nẵng");
        cinema.setPhone("0236.3888.999");
        cinema.setEmail("info@cinemaparadise.vn");
        cinema.setDescription("Rạp chiếu phim hiện đại với 4 phòng chiếu, mỗi phòng có 50 ghế được chia thành 3 loại: VIP, Thường và Couple");
        cinema.setOpeningHours("8:00 - 23:00 hàng ngày");
        cinema = theaterRepository.save(cinema);
        
        // Tạo 4 phòng chiếu
        create4Auditoriums(cinema);
        
        System.out.println("🏢 Created cinema: " + cinema.getName());
    }
    
    private void create4Auditoriums(Theater cinema) {
        String[] auditoriumNames = {"Phòng 1", "Phòng 2", "Phòng 3", "Phòng 4"};
        String[] screenTypes = {"2D/3D", "2D/3D", "2D/3D", "2D/3D"};
        String[] soundSystems = {"Dolby Atmos", "DTS", "THX", "Standard"};
        
        for (int i = 0; i < 4; i++) {
            Auditorium auditorium = new Auditorium();
            auditorium.setTheater(cinema);
            auditorium.setName(auditoriumNames[i]);
            auditorium.setTotalSeats(50);
            auditorium.setScreenType(screenTypes[i]);
            auditorium.setSoundSystem(soundSystems[i]);
            auditorium = auditoriumRepository.save(auditorium);
            
            // Tạo 50 ghế cho mỗi phòng
            create50SeatsForAuditorium(auditorium);
            
            System.out.println("🎭 Created " + auditorium.getName() + " with 50 seats");
        }
    }
    
    private void create50SeatsForAuditorium(Auditorium auditorium) {
        // Cấu trúc ghế cho mỗi phòng 50 ghế:
        // Hàng A, B: VIP (20 ghế) - 2 hàng x 10 ghế - hệ số 1.5
        // Hàng C, D, E: STANDARD (21 ghế) - 3 hàng x 7 ghế - hệ số 1.0  
        // Hàng F: COUPLE (9 ghế) - 1 hàng x 9 ghế - hệ số 1.3
        
        int seatCount = 0;
        
        // Hàng A, B: VIP (20 ghế)
        for (int row = 0; row < 2; row++) {
            String rowNumber = String.valueOf((char) ('A' + row));
            for (int position = 1; position <= 10; position++) {
                Seat seat = new Seat();
                seat.setAuditorium(auditorium);
                seat.setRowNumber(rowNumber);
                seat.setSeatPosition(position);
                seat.setSeatType(Seat.SeatType.VIP);
                seat.setPriceModifier(new BigDecimal("1.50"));
                seatRepository.save(seat);
                seatCount++;
            }
        }
        
        // Hàng C, D, E: STANDARD (21 ghế)
        for (int row = 2; row < 5; row++) {
            String rowNumber = String.valueOf((char) ('A' + row));
            for (int position = 1; position <= 7; position++) {
                Seat seat = new Seat();
                seat.setAuditorium(auditorium);
                seat.setRowNumber(rowNumber);
                seat.setSeatPosition(position);
                seat.setSeatType(Seat.SeatType.STANDARD);
                seat.setPriceModifier(new BigDecimal("1.00"));
                seatRepository.save(seat);
                seatCount++;
            }
        }
        
        // Hàng F: COUPLE (9 ghế)
        String rowNumber = "F";
        for (int position = 1; position <= 9; position++) {
            Seat seat = new Seat();
            seat.setAuditorium(auditorium);
            seat.setRowNumber(rowNumber);
            seat.setSeatPosition(position);
            seat.setSeatType(Seat.SeatType.COUPLE);
            seat.setPriceModifier(new BigDecimal("1.30"));
            seatRepository.save(seat);
            seatCount++;
        }
        
        // Cập nhật lại tổng số ghế thực tế
        auditorium.setTotalSeats(seatCount);
        auditoriumRepository.save(auditorium);
    }
    
    private void createSampleMovies() {
        if (movieRepository.count() > 0) {
            System.out.println("📽️ Movies already exist in database");
            return;
        }
        
        // Tạo một số phim mẫu
        Movie movie1 = new Movie();
        movie1.setTitle("Oppenheimer");
        movie1.setDurationMin(180);
        movie1.setGenre("Drama, History");
        movie1.setDescription("Câu chuyện về J. Robert Oppenheimer, nhà khoa học được giao nhiệm vụ phát triển bom nguyên tử trong Thế chiến II.");
        movie1.setPosterUrl("https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg");
        movie1.setRating("R");
        movieRepository.save(movie1);
        
        Movie movie2 = new Movie();
        movie2.setTitle("Barbie");
        movie2.setDurationMin(114);
        movie2.setGenre("Comedy, Adventure");
        movie2.setDescription("Barbie và Ken đang có một ngày tuyệt vời ở thế giới màu hồng, hoàn hảo của họ trong Barbieland.");
        movie2.setPosterUrl("https://image.tmdb.org/t/p/w500/iuFNMS8U5cb6xfzi51Dbkovj7vM.jpg");
        movie2.setRating("PG-13");
        movieRepository.save(movie2);
        
        Movie movie3 = new Movie();
        movie3.setTitle("Spider-Man: Across the Spider-Verse");
        movie3.setDurationMin(140);
        movie3.setGenre("Animation, Action");
        movie3.setDescription("Sau khi đoàn tụ với Gwen Stacy, Spider-Man thân thiện của Brooklyn được thúc đẩy khắp Đa vũ trụ.");
        movie3.setPosterUrl("https://image.tmdb.org/t/p/w500/8Vt6mWEReuy4Of61Lnj5Xj704m8.jpg");
        movie3.setRating("PG");
        movieRepository.save(movie3);
        
        System.out.println("📽️ Created 3 sample movies");
    }
    
    private void createSampleScreenings() {
        List<Movie> movies = movieRepository.findAll();
        List<Auditorium> auditoriums = auditoriumRepository.findAll();
        
        if (movies.isEmpty() || auditoriums.isEmpty()) {
            return;
        }
        
        // Tạo suất chiếu cho 3 ngày tới
        LocalDateTime now = LocalDateTime.now();
        
        for (int day = 0; day < 3; day++) {
            LocalDateTime currentDay = now.plusDays(day);
            
            // Mỗi ngày mỗi phòng chiếu 2-3 suất
            for (int auditoriumIndex = 0; auditoriumIndex < auditoriums.size(); auditoriumIndex++) {
                Auditorium auditorium = auditoriums.get(auditoriumIndex);
                Movie movie = movies.get(auditoriumIndex % movies.size()); // Xoay vòng phim
                
                // Tạo 3 suất chiếu mỗi ngày cho mỗi phòng
                int[] timeSlots = {9, 14, 19}; // 9h sáng, 2h chiều, 7h tối
                
                for (int slot : timeSlots) {
                    LocalDateTime startTime = currentDay
                        .withHour(slot)
                        .withMinute(0)
                        .withSecond(0);
                        
                    Screening screening = new Screening();
                    screening.setAuditorium(auditorium);
                    screening.setStartTime(startTime);
                    
                    // Giá vé cơ bản 120,000 VND
                    BigDecimal basePrice = new BigDecimal("120000");
                    
                    // Giá cao hơn vào buổi tối và cuối tuần
                    if (slot >= 19) {
                        basePrice = basePrice.multiply(new BigDecimal("1.25")); // +25% buổi tối
                    }
                    
                    if (startTime.getDayOfWeek().getValue() >= 6) {
                        basePrice = basePrice.multiply(new BigDecimal("1.15")); // +15% cuối tuần
                    }
                    
                    screening.setTicketPrice(basePrice);
                    // Set movie after other properties to avoid lazy initialization issue
                    screening.setMovie(movie);
                    
                    screeningRepository.save(screening);
                }
            }
        }
        
        System.out.println("🎬 Created sample screenings for next 3 days");
    }
    
    private void createAdminUser() {
        if (userRepository.findByUsername("admin").isPresent()) {
            System.out.println("👤 Admin user already exists");
            return;
        }
        
        User admin = new User();
        admin.setUsername("admin");
        admin.setEmail("admin@cinemaparadise.vn");
        admin.setPasswordHash("$2a$12$ql7t3dfII28oIf.6sUe/Uuomu.ClsPplwpbY8pMo83JAI6VwSn5Ra"); // password
        admin.setRole(User.Role.ADMIN);
        admin.setFullName("Cinema Administrator");
        admin.setIsEnabled(true);
        userRepository.save(admin);
        
        System.out.println("👤 Created admin user (username: admin, password: password)");
    }
}
