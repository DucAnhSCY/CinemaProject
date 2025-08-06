# 🎬 Cinema Project

Hệ thống quản lý rạp chiếu phim được xây dựng với Spring Boot và React.

## 🌟 Features

- **Quản lý phim**: Thêm, sửa, xóa phim với thông tin chi tiết
- **Quản lý rạp chiếu**: Quản lý các rạp và phòng chiếu
- **Lịch chiếu**: Tạo và quản lý lịch chiếu phim
- **Đặt vé**: Hệ thống đặt vé trực tuyến
- **Quản lý người dùng**: Hệ thống xác thực và phân quyền
- **Dashboard admin**: Thống kê và báo cáo

## 🚀 Quick Start với Docker Hub

### Cách nhanh nhất để chạy ứng dụng:

```bash
# Clone repository
git clone https://github.com/DucAnhSCY/CinemaProject.git
cd CinemaProject

# Chạy từ Docker Hub (không cần build)
docker-run-prod.bat
```

Ứng dụng sẽ chạy tại: http://localhost:8081

### Hoặc chạy trực tiếp với Docker:

```bash
docker pull ducanh/cinema-project:latest
docker run -d --name cinema-app -p 8081:8080 ducanh/cinema-project:latest
```

## 🛠️ Development Setup

### Yêu cầu hệ thống:
- Java 21
- Maven 3.6+
- SQL Server 2019+
- Docker Desktop (optional)

### Chạy local:

```bash
# Clone repository
git clone https://github.com/DucAnhSCY/CinemaProject.git
cd CinemaProject

# Build và chạy với Docker
docker-compose up --build

# Hoặc chạy với Maven
./mvnw spring-boot:run
```

## � CI/CD Pipeline

### GitHub Actions (Recommended)
Tự động build và push lên Docker Hub khi:
- Push code lên `main` hoặc `develop`
- Tạo tag release

### Jenkins Integration 🆕
Pipeline hoàn chỉnh với Docker Hub:
```bash
# Test pipeline locally
./test-jenkins-pipeline.ps1

# Setup Jenkins với Docker Hub
# Xem hướng dẫn: docs/jenkins-docker-setup.md
```

**Jenkins Pipeline Features:**
- ✅ Tự động build từ GitHub
- ✅ Maven test & package  
- ✅ Docker build & test
- ✅ Push lên Docker Hub
- ✅ Deploy từ Docker Hub
- ✅ Health check & monitoring
- ✅ Auto cleanup old images

## �📦 Docker Hub

Image có sẵn trên Docker Hub: [`ducanh/cinema-project`](https://hub.docker.com/r/ducanhscy/cinema-project)

### Available Tags:
- `latest` - Version mới nhất
- `main` - Build từ main branch  
- `develop` - Build từ develop branch
- `v1.0.0` - Tagged releases

## 🗄️ Database

Ứng dụng sử dụng SQL Server database. Cấu hình mặc định:
- Host: `34.71.252.111:1433`
- Database: `cinema`
- Username: `sqlserver`
- Password: `123`

## 📁 Cấu trúc Project

```
CinemaProject/
├── src/main/java/com/N07/         # Source code chính
├── src/main/resources/
│   ├── templates/                 # Thymeleaf templates
│   ├── static/                    # CSS, JS, images
│   └── application.properties     # Cấu hình ứng dụng
├── src/test/                      # Test files
├── docker-compose.yml             # Development setup
├── docker-compose.prod.yml        # Production setup
├── Dockerfile                     # Docker build file
└── .github/workflows/             # CI/CD workflows
```

## 🔧 Scripts

- `docker-run.bat` - Chạy development version
- `docker-run-prod.bat` - Chạy production từ Docker Hub
- `docker-stop.bat` - Dừng development containers
- `docker-stop-prod.bat` - Dừng production containers
- `docker-push.bat` - Build và push lên Docker Hub

## 📖 Documentation

Xem thêm:
- [Docker Setup Guide](DOCKER-README.md)
- [Jenkins + Docker Hub Setup](docs/jenkins-docker-setup.md) 🆕
- [Deployment Guide](docs/deployment.md)
- [API Documentation](docs/api.md) (coming soon)

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **DucAnh** - *Lead Developer* - [@DucAnhSCY](https://github.com/DucAnhSCY)

## 🙏 Acknowledgments

- Spring Boot team
- Thymeleaf community
- Bootstrap team
