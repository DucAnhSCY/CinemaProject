# Cinema Project - Docker Setup

Hướng dẫn chạy Cinema Project bằng Docker và Docker Hub.

## Yêu cầu

- Docker Desktop đã được cài đặt và chạy
- Docker Compose (thường đi cùng với Docker Desktop)
- Tài khoản Docker Hub (nếu muốn push/pull từ Docker Hub)

## 🚀 Cách chạy từ Docker Hub (Khuyến nghị)

### Chạy nhanh từ Docker Hub
```bash
# Pull và chạy từ Docker Hub
docker-run-prod.bat

# Dừng ứng dụng
docker-stop-prod.bat
```

### Chạy trực tiếp với Docker
```bash
# Pull image từ Docker Hub
docker pull ducanh/cinema-project:latest

# Chạy container
docker run -d \
  --name cinema-app \
  -p 8081:8080 \
  -e SPRING_PROFILES_ACTIVE=docker \
  -e SPRING_DATASOURCE_URL="jdbc:sqlserver://34.71.252.111:1433;databaseName=cinema;encrypt=false;trustServerCertificate=true" \
  -e SPRING_DATASOURCE_USERNAME=sqlserver \
  -e SPRING_DATASOURCE_PASSWORD=123 \
  ducanh/cinema-project:latest
```

## 🔧 Build và Development

### Option 1: Sử dụng script (Đơn giản nhất)
```bash
# Build và chạy local
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

## 📦 Publish lên Docker Hub

### Thủ công (Manual)
```bash
# Build và push lên Docker Hub
docker-push.bat

# Hoặc thủ công:
docker build -t ducanh/cinema-project:latest .
docker login
docker push ducanh/cinema-project:latest
```

### Tự động (GitHub Actions)
Project đã có GitHub Actions workflow sẽ tự động build và push lên Docker Hub khi:
- Push code lên branch `main` hoặc `develop`
- Tạo tag version (v1.0.0, v1.1.0, etc.)

Để sử dụng GitHub Actions, cần set up secrets trong GitHub repository:
- `DOCKER_USERNAME`: Docker Hub username
- `DOCKER_PASSWORD`: Docker Hub password hoặc access token

## 🌐 Sử dụng Image từ Docker Hub

### Pull image
```bash
docker pull ducanh/cinema-project:latest
```

### Các tag available:
- `latest`: Version mới nhất từ main branch
- `main`: Build từ main branch
- `develop`: Build từ develop branch
- `v1.0.0`, `v1.1.0`: Các version releases

## Kiểm tra ứng dụng

Sau khi chạy thành công:
- Ứng dụng: http://localhost:8081 (production) hoặc http://localhost:8080 (development)
- Health check: http://localhost:8081/actuator/health

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
# Development
docker-compose logs cinema-app

# Production
docker logs cinema-app-prod -f
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

### Pull image mới từ Docker Hub
```bash
# Stop container cũ
docker-stop-prod.bat

# Pull image mới và chạy
docker-run-prod.bat
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
