# Cinema Project - Hệ Thống Đặt Vé Rạp Chiếu Phim (Single Cinema)

## Tổng Quan

Dự án đã được điều chỉnh để tập trung vào **hệ thống 1 rạp chiếu phim duy nhất** thay vì đa rạp. Điều này giúp đơn giản hóa logic quản lý và tập trung vào việc hoàn thiện các tính năng cốt lõi của đặt vé phim.

## Thay Đổi Chính

### 1. Cơ Sở Dữ Liệu
- **File mới**: `single_cinema_db.sql` - Schema tối ưu cho 1 rạp duy nhất
- **Rạp duy nhất**: Cinema Paradise tại Đà Nẵng
- **5 phòng chiếu đa dạng**:
  - Phòng VIP (50 ghế) - 2D/3D, Dolby Atmos
  - Phòng Standard (120 ghế) - 2D, DTS  
  - Phòng IMAX (200 ghế) - IMAX, IMAX Sound
  - Phòng 4DX (80 ghế) - 4DX, 4DX Sound
  - Phòng Family (150 ghế) - 2D/3D, THX

### 2. Backend Changes

#### New Services
- **`SingleCinemaService`**: Service chính cho logic 1 rạp
  - Quản lý thông tin rạp
  - Lấy danh sách suất chiếu
  - Thống kê và báo cáo
  
#### Enhanced Entities
- **`Theater`**: Thêm phone, email, description, openingHours
- **`Auditorium`**: Thêm screenType, soundSystem
- **`Seat`**: Thêm priceModifier cho giá linh hoạt

#### New Controllers
- **`SingleCinemaController`**: Controller chính thay thế TheaterController
  - `/cinema/info` - Thông tin rạp
  - `/cinema/schedule` - Lịch chiếu
  - `/cinema/movies` - Phim đang chiếu

#### Data Initialization
- **`SingleCinemaDataLoader`**: Tự động khởi tạo dữ liệu mẫu
- **Chuyển đổi tự động**: Nếu có nhiều rạp, tự động chuyển về 1 rạp

### 3. Tính Năng Mới

#### Hệ Thống Giá Linh Hoạt
- Giá cơ bản theo phòng chiếu
- Hệ số nhân theo loại ghế (VIP 1.5x, Standard 1.0x)
- Giá cao hơn vào cuối tuần (1.2x)

#### Quản Lý Đơn Giản
- Tự động lọc phim có suất chiếu
- Giao diện tập trung vào 1 rạp
- Loại bỏ việc chọn rạp trong quy trình đặt vé

## Cài Đặt và Chạy

### 1. Cơ Sở Dữ Liệu
```sql
-- Chạy file SQL mới
-- c:\Users\DucAnh\Documents\GitHub\CinemaProject\single_cinema_db.sql
```

### 2. Chạy Ứng Dụng
```bash
mvn clean spring-boot:run
```

### 3. Truy Cập
- **Trang chủ**: http://localhost:8080
- **Thông tin rạp**: http://localhost:8080/cinema/info
- **Lịch chiếu**: http://localhost:8080/cinema/schedule
- **Admin**: http://localhost:8080/admin (admin/password)

## Cấu Trúc Thư Mục

```
src/main/java/com/N07/CinemaProject/
├── controller/
│   ├── SingleCinemaController.java (MỚI)
│   ├── HomeController.java (CẬP NHẬT)
│   └── ...
├── service/
│   ├── SingleCinemaService.java (MỚI)
│   └── ...
├── entity/
│   ├── Theater.java (CẬP NHẬT)
│   ├── Auditorium.java (CẬP NHẬT)
│   ├── Seat.java (CẬP NHẬT)
│   └── ...
├── config/
│   ├── SingleCinemaDataLoader.java (MỚI)
│   └── ...
└── repository/
    ├── ScreeningRepository.java (CẬP NHẬT)
    └── ...
```

## API Endpoints Mới

### Public Endpoints
- `GET /cinema/info` - Thông tin rạp chiếu phim
- `GET /cinema/schedule` - Lịch chiếu phim
- `GET /cinema/movies` - Danh sách phim đang chiếu

### Redirects (Backward Compatibility)
- `/theaters` → `/cinema/info`
- `/theaters/{id}` → `/cinema/info`

## Database Schema Highlights

### Key Tables
1. **theaters** - 1 rạp duy nhất với thông tin chi tiết
2. **auditoriums** - 5 phòng chiếu với các loại khác nhau
3. **seats** - Ghế với price_modifier linh hoạt
4. **screenings** - Suất chiếu với base_price
5. **bookings** - Đặt vé với booking_code tự động

### Views
- `v_screening_details` - Chi tiết suất chiếu đầy đủ
- `v_booking_details` - Chi tiết đặt vé với ghế

### Stored Procedures
- `sp_generate_booking_code` - Tạo mã đặt vé tự động

## Tính Năng Tương Lai

### Phase 1 (Hiện tại)
- ✅ Hệ thống 1 rạp duy nhất
- ✅ Đặt vé cơ bản
- ✅ Quản lý phim và suất chiếu
- ✅ Hệ thống giá linh hoạt

### Phase 2 (Sắp tới)
- 🔄 Thanh toán online
- 🔄 Hệ thống khuyến mãi nâng cao
- 🔄 Báo cáo và thống kê chi tiết
- 🔄 Mobile responsive

### Phase 3 (Tương lai xa)
- 📋 Mở rộng thành đa rạp
- 📋 API cho mobile app
- 📋 Tích hợp AI recommendations
- 📋 Loyalty program

## Lưu Ý Quan Trọng

1. **Migration**: Hệ thống tự động chuyển đổi từ đa rạp về 1 rạp khi khởi động
2. **Data Integrity**: Tất cả booking và screening hiện tại được giữ nguyên
3. **Backward Compatibility**: Các URL cũ được redirect tự động
4. **Performance**: Tối ưu hóa cho 1 rạp giúp cải thiện hiệu suất

## Support

- **Email**: admin@cinemaparadise.vn
- **Phone**: 0236.3888.999
- **Address**: 123 Lê Duẩn, Quận Hải Châu, Đà Nẵng

---

**Cinema Paradise** - *Trải nghiệm điện ảnh đẳng cấp*
