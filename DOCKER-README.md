# Cinema Project - Docker Setup

Hướng dẫn chạy Cinema Project bằng Docker.

## Yêu cầu

- Docker Desktop đã được cài đặt và chạy
- Docker Compose (thường đi cùng với Docker Desktop)

## Cách chạy nhanh

### Option 1: Sử dụng script (Đơn giản nhất)
```bash
# Chạy ứng dụng
docker-run.bat

# Dừng ứng dụng
docker-stop.bat
```

### Option 2: Sử dụng docker-compose trực tiếp
```bash
# Build và chạy containers
docker-compose up --build -d

# Xem logs
docker-compose logs -f cinema-app

# Dừng containers
docker-compose down
```

### Option 3: Chỉ build Docker image
```bash
# Build image
docker build -t cinema-app:latest .

# Chạy container
docker run -d -p 8080:8080 --name cinema-app cinema-app:latest
```

## Kiểm tra ứng dụng

Sau khi chạy thành công:
- Ứng dụng: http://localhost:8080
- Health check: http://localhost:8080/actuator/health

## Cấu hình

### Database
Mặc định ứng dụng kết nối đến SQL Server external:
- Host: 34.71.252.111:1433
- Database: cinema
- Username: sqlserver
- Password: 123

### Environment Variables
Có thể override các cấu hình thông qua environment variables trong `docker-compose.yml`:
- `SPRING_DATASOURCE_URL`
- `SPRING_DATASOURCE_USERNAME`
- `SPRING_DATASOURCE_PASSWORD`
- `SERVER_PORT`

## Troubleshooting

### Xem logs
```bash
docker-compose logs cinema-app
```

### Container không start
```bash
# Kiểm tra status
docker-compose ps

# Xem logs chi tiết
docker-compose logs cinema-app

# Rebuild image
docker-compose up --build --force-recreate
```

### Port đã được sử dụng
Thay đổi port mapping trong `docker-compose.yml`:
```yaml
ports:
  - "8081:8080"  # Sử dụng port 8081 thay vì 8080
```

### Database connection issues
Kiểm tra:
1. SQL Server có thể kết nối từ Docker container
2. Firewall settings
3. Database credentials

## File Structure

```
.
├── Dockerfile              # Docker image definition
├── docker-compose.yml      # Multi-container setup
├── .dockerignore           # Files to ignore in Docker build
├── docker-run.bat          # Script to start application
├── docker-stop.bat         # Script to stop application
└── src/main/resources/
    └── application-docker.properties  # Docker-specific config
```
