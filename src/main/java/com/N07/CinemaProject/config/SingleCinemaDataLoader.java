package com.N07.CinemaProject.config;

import com.N07.CinemaProject.entity.*;
import com.N07.CinemaProject.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Khởi tạo dữ liệu mẫu cho hệ thống 1 rạp duy nhất
 */
@Component
@Order(2) // Chạy sau các CommandLineRunner khác
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
    
    @Override
    public void run(String... args) throws Exception {
        // Kiểm tra xem đã có dữ liệu chưa
        if (theaterRepository.count() > 0) {
            System.out.println("Database already contains theater data. Skipping initialization.");
            
            // Nếu có nhiều hơn 1 rạp, chuyển về 1 rạp duy nhất
            if (theaterRepository.count() > 1) {
                convertToSingleCinema();
            }
            return;
        }
        
        System.out.println("Initializing single cinema system...");
        
        createSingleCinema();
        createSampleMovies();
        createSampleScreenings();
        createAdminUser();
        
        System.out.println("Single cinema system initialized successfully!");
    }
    
    private void convertToSingleCinema() {
        System.out.println("Converting multi-theater system to single cinema...");
        
        // Lấy rạp đầu tiên làm rạp chính
        List<Theater> theaters = theaterRepository.findAll();
        Theater mainTheater = theaters.get(0);
        
        // Cập nhật thông tin rạp chính
        mainTheater.setName("Cinema Paradise");
        mainTheater.setCity("Đà Nẵng");
        mainTheater.setAddress("123 Lê Duẩn, Quận Hải Châu, Đà Nẵng");
        mainTheater.setPhone("0236.3888.999");
        mainTheater.setEmail("info@cinemaparadise.vn");
        mainTheater.setDescription("Rạp chiếu phim hiện đại với công nghệ âm thanh và hình ảnh tối tân");
        mainTheater.setOpeningHours("8:00 - 23:00 hàng ngày");
        theaterRepository.save(mainTheater);
        
        // Chuyển tất cả auditorium về rạp chính
        List<Auditorium> allAuditoriums = auditoriumRepository.findAll();
        for (Auditorium auditorium : allAuditoriums) {
            auditorium.setTheater(mainTheater);
            auditoriumRepository.save(auditorium);
        }
        
        // Xóa các rạp khác
        for (int i = 1; i < theaters.size(); i++) {
            theaterRepository.delete(theaters.get(i));
        }
        
        System.out.println("Converted to single cinema: " + mainTheater.getName());
    }
    
    private void createSingleCinema() {
        // Tạo rạp chiếu phim duy nhất
        Theater cinema = new Theater();
        cinema.setName("Cinema Paradise");
        cinema.setCity("Đà Nẵng");
        cinema.setAddress("123 Lê Duẩn, Quận Hải Châu, Đà Nẵng");
        cinema.setPhone("0236.3888.999");
        cinema.setEmail("info@cinemaparadise.vn");
        cinema.setDescription("Rạp chiếu phim hiện đại với công nghệ âm thanh và hình ảnh tối tân");
        cinema.setOpeningHours("8:00 - 23:00 hàng ngày");
        cinema = theaterRepository.save(cinema);
        
        // Tạo 5 phòng chiếu đa dạng
        createAuditoriums(cinema);
        
        System.out.println("Created cinema: " + cinema.getName());
    }
    
    private void createAuditoriums(Theater cinema) {
        // Phòng VIP
        Auditorium vipAuditorium = new Auditorium();
        vipAuditorium.setTheater(cinema);
        vipAuditorium.setName("Phòng VIP");
        vipAuditorium.setTotalSeats(50);
        vipAuditorium.setScreenType("2D/3D");
        vipAuditorium.setSoundSystem("Dolby Atmos");
        vipAuditorium = auditoriumRepository.save(vipAuditorium);
        createSeatsForAuditorium(vipAuditorium, 5, 10); // 5 hàng, 10 ghế mỗi hàng
        
        // Phòng Standard
        Auditorium standardAuditorium = new Auditorium();
        standardAuditorium.setTheater(cinema);
        standardAuditorium.setName("Phòng Standard");
        standardAuditorium.setTotalSeats(120);
        standardAuditorium.setScreenType("2D");
        standardAuditorium.setSoundSystem("DTS");
        standardAuditorium = auditoriumRepository.save(standardAuditorium);
        createSeatsForAuditorium(standardAuditorium, 8, 15); // 8 hàng, 15 ghế mỗi hàng
        
        // Phòng IMAX
        Auditorium imaxAuditorium = new Auditorium();
        imaxAuditorium.setTheater(cinema);
        imaxAuditorium.setName("Phòng IMAX");
        imaxAuditorium.setTotalSeats(200);
        imaxAuditorium.setScreenType("IMAX");
        imaxAuditorium.setSoundSystem("IMAX Sound");
        imaxAuditorium = auditoriumRepository.save(imaxAuditorium);
        createSeatsForAuditorium(imaxAuditorium, 10, 20); // 10 hàng, 20 ghế mỗi hàng
        
        // Phòng 4DX
        Auditorium fourDxAuditorium = new Auditorium();
        fourDxAuditorium.setTheater(cinema);
        fourDxAuditorium.setName("Phòng 4DX");
        fourDxAuditorium.setTotalSeats(80);
        fourDxAuditorium.setScreenType("4DX");
        fourDxAuditorium.setSoundSystem("4DX Sound");
        fourDxAuditorium = auditoriumRepository.save(fourDxAuditorium);
        createSeatsForAuditorium(fourDxAuditorium, 8, 10); // 8 hàng, 10 ghế mỗi hàng
        
        // Phòng Family
        Auditorium familyAuditorium = new Auditorium();
        familyAuditorium.setTheater(cinema);
        familyAuditorium.setName("Phòng Family");
        familyAuditorium.setTotalSeats(150);
        familyAuditorium.setScreenType("2D/3D");
        familyAuditorium.setSoundSystem("THX");
        familyAuditorium = auditoriumRepository.save(familyAuditorium);
        createSeatsForAuditorium(familyAuditorium, 10, 15); // 10 hàng, 15 ghế mỗi hàng
        
        System.out.println("Created 5 auditoriums with different configurations");
    }
    
    private void createSeatsForAuditorium(Auditorium auditorium, int rows, int seatsPerRow) {
        String[] rowLabels = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O"};
        
        for (int row = 0; row < rows; row++) {
            String rowLabel = rowLabels[row];
            
            for (int seatNum = 1; seatNum <= seatsPerRow; seatNum++) {
                Seat seat = new Seat();
                seat.setAuditorium(auditorium);
                seat.setRowNumber(rowLabel);
                seat.setSeatPosition(seatNum);
                
                // Xác định loại ghế và giá
                if (auditorium.getName().contains("VIP") && (row == 0 || row == 1)) {
                    seat.setSeatType(Seat.SeatType.VIP);
                    seat.setPriceModifier(new BigDecimal("1.5"));
                } else if (auditorium.getName().contains("4DX") || auditorium.getName().contains("IMAX")) {
                    seat.setSeatType(Seat.SeatType.VIP);
                    seat.setPriceModifier(new BigDecimal("2.0"));
                } else {
                    seat.setSeatType(Seat.SeatType.STANDARD);
                    seat.setPriceModifier(new BigDecimal("1.0"));
                }
                
                seatRepository.save(seat);
            }
        }
    }
    
    private void createSampleMovies() {
        if (movieRepository.count() > 0) {
            System.out.println("Movies already exist in database");
            return;
        }
        
        // Tạo một số phim mẫu nếu chưa có
        Movie movie1 = new Movie();
        movie1.setTitle("Avengers: Endgame");
        movie1.setDurationMin(181);
        movie1.setGenre("Action, Adventure, Drama");
        movie1.setDescription("Sau sự kiện của Infinity War, các siêu anh hùng sống sót tập hợp một lần nữa...");
        movie1.setPosterUrl("https://image.tmdb.org/t/p/w500/or06FN3Dka5tukK1e9sl16pB3iy.jpg");
        movie1.setRating("PG-13");
        movieRepository.save(movie1);
        
        Movie movie2 = new Movie();
        movie2.setTitle("Spider-Man: No Way Home");
        movie2.setDurationMin(148);
        movie2.setGenre("Action, Adventure, Fantasy");
        movie2.setDescription("Peter Parker đối mặt với hậu quả khi danh tính của anh bị tiết lộ...");
        movie2.setPosterUrl("https://image.tmdb.org/t/p/w500/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg");
        movie2.setRating("PG-13");
        movieRepository.save(movie2);
        
        System.out.println("Created sample movies");
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
            
            for (Movie movie : movies) {
                for (Auditorium auditorium : auditoriums) {
                    // Tạo 3 suất chiếu mỗi ngày cho mỗi phim trong mỗi phòng
                    for (int slot = 0; slot < 3; slot++) {
                        LocalDateTime startTime = currentDay
                            .withHour(9 + slot * 4) // 9h, 13h, 17h, 21h
                            .withMinute(0)
                            .withSecond(0);
                            
                        Screening screening = new Screening();
                        screening.setMovie(movie);
                        screening.setAuditorium(auditorium);
                        screening.setStartTime(startTime);
                        
                        // Giá vé khác nhau theo phòng
                        BigDecimal basePrice;
                        if (auditorium.getName().contains("IMAX")) {
                            basePrice = new BigDecimal("200000");
                        } else if (auditorium.getName().contains("4DX")) {
                            basePrice = new BigDecimal("250000");
                        } else if (auditorium.getName().contains("VIP")) {
                            basePrice = new BigDecimal("150000");
                        } else {
                            basePrice = new BigDecimal("100000");
                        }
                        
                        // Giá cao hơn vào cuối tuần
                        if (startTime.getDayOfWeek().getValue() >= 6) {
                            basePrice = basePrice.multiply(new BigDecimal("1.2"));
                        }
                        
                        screening.setTicketPrice(basePrice);
                        screeningRepository.save(screening);
                    }
                }
            }
        }
        
        System.out.println("Created sample screenings for next 3 days");
    }
    
    private void createAdminUser() {
        if (userRepository.findByUsername("admin").isPresent()) {
            return;
        }
        
        User admin = new User();
        admin.setUsername("admin");
        admin.setEmail("admin@cinemaparadise.vn");
        admin.setPasswordHash("$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi"); // password
        admin.setRole(User.Role.ADMIN);
        admin.setFullName("Cinema Administrator");
        admin.setIsEnabled(true);
        userRepository.save(admin);
        
        System.out.println("Created admin user (username: admin, password: password)");
    }
}
