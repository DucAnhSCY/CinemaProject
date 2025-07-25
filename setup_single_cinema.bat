@echo off
echo ====================================
echo Cinema Project - Single Cinema Setup
echo ====================================
echo.

echo Thiết lập hệ thống 1 rạp chiếu phim duy nhất...
echo.

echo BƯỚC 1: Backup database hiện tại (nếu có)
echo Vui lòng backup database của bạn trước khi tiếp tục!
echo.
pause

echo BƯỚC 2: Chạy script SQL mới
echo.
echo Vui lòng thực hiện các bước sau:
echo 1. Mở SQL Server Management Studio
echo 2. Kết nối đến database server
echo 3. Tạo database mới: cinema_db (nếu chưa có)
echo 4. Chạy file: single_cinema_db.sql
echo.
echo Hoặc sử dụng command line:
echo sqlcmd -S localhost -d cinema_db -i single_cinema_db.sql
echo.
pause

echo BƯỚC 3: Cập nhật application.properties
echo.
echo Đảm bảo file src/main/resources/application.properties có cấu hình đúng:
echo.
echo spring.datasource.url=jdbc:sqlserver://localhost:1433;databaseName=cinema_db
echo spring.datasource.username=your_username
echo spring.datasource.password=your_password
echo spring.jpa.hibernate.ddl-auto=none
echo.
pause

echo BƯỚC 4: Chạy ứng dụng
echo.
echo mvn clean spring-boot:run
echo.
echo Hoặc trong IDE:
echo 1. Mở CinemaProjectApplication.java
echo 2. Click Run/Debug
echo.
pause

echo BƯỚC 5: Truy cập ứng dụng
echo.
echo Sau khi khởi động thành công:
echo - Trang chủ: http://localhost:8080
echo - Thông tin rạp: http://localhost:8080/cinema/info
echo - Admin: http://localhost:8080/admin (admin/password)
echo.

echo ====================================
echo Thiết lập hoàn tất!
echo ====================================
echo.
echo Tính năng mới:
echo - Hệ thống 1 rạp duy nhất: Cinema Paradise
echo - 5 phòng chiếu với công nghệ khác nhau
echo - Hệ thống giá linh hoạt theo loại ghế
echo - Giao diện đơn giản hóa
echo - Tự động khởi tạo dữ liệu mẫu
echo.
echo Chúc bạn phát triển thành công!
pause
