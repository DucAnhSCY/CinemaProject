# 🔧 Jenkins Setup Guide for Docker Hub Integration

Hướng dẫn cấu hình Jenkins để tích hợp với Docker Hub cho dự án Cinema.

## 📋 Yêu cầu trước khi setup

### 1. Jenkins Requirements
- Jenkins 2.400+ đã cài đặt
- Các plugins cần thiết:
  - **Docker Pipeline Plugin**
  - **Docker Plugin** 
  - **Git Plugin**
  - **Pipeline Plugin**
  - **Credentials Plugin**
  - **Blue Ocean** (optional, cho UI đẹp hơn)

### 2. System Requirements
- Docker Desktop đã cài đặt và chạy
- Git đã cài đặt
- Internet connection để push lên Docker Hub

## 🔑 Setup Docker Hub Credentials

### Bước 1: Tạo Docker Hub Access Token
1. Đăng nhập vào [Docker Hub](https://hub.docker.com)
2. Vào **Account Settings** > **Security**
3. Click **New Access Token**
4. Nhập tên token: `jenkins-cinema-project`
5. Select scope: **Read, Write**
6. Copy token (chỉ hiển thị 1 lần!)

### Bước 2: Thêm Credentials trong Jenkins
1. Vào Jenkins Dashboard
2. **Manage Jenkins** > **Manage Credentials**
3. Click vào **(global)** domain
4. **Add Credentials**
5. Chọn **Username with password**
6. Nhập thông tin:
   - **Username**: Docker Hub username của bạn
   - **Password**: Access token vừa tạo
   - **ID**: `docker-hub-credentials`
   - **Description**: `Docker Hub Access Token for Cinema Project`
7. Click **OK**

## 🚀 Setup Jenkins Pipeline

### Bước 1: Tạo New Pipeline Job
1. **New Item** > **Pipeline**
2. Tên job: `Cinema-Project-Pipeline`
3. Trong **Pipeline** section:
   - **Definition**: Pipeline script from SCM
   - **SCM**: Git
   - **Repository URL**: `https://github.com/DucAnhSCY/CinemaProject.git`
   - **Branch**: `*/main`
   - **Script Path**: `Jenkinsfile`

### Bước 2: Configure Build Triggers
1. Tick **GitHub hook trigger for GITScm polling**
2. Hoặc tick **Poll SCM** với schedule: `H/5 * * * *` (check mỗi 5 phút)

### Bước 3: Environment Variables (Optional)
Trong **Pipeline** section, có thể thêm **Environment Variables**:
```
DOCKER_IMAGE_NAME=ducanhscy/cinema-project
DEPLOY_METHOD=docker
```

## 🔗 Setup GitHub Webhook (Recommended)

### Bước 1: Trong GitHub Repository
1. Vào repository settings
2. **Webhooks** > **Add webhook**
3. **Payload URL**: `http://your-jenkins-url/github-webhook/`
4. **Content type**: `application/json`
5. **Events**: Just the push event
6. **Active**: ✅

### Bước 2: Test Webhook
1. Push một commit nhỏ lên GitHub
2. Kiểm tra Jenkins có trigger build tự động không

## 🐳 Docker Hub Repository Setup

### Tạo Repository trên Docker Hub
1. Đăng nhập vào Docker Hub
2. **Create Repository**
3. **Name**: `cinema-project`
4. **Visibility**: Public (hoặc Private nếu cần)
5. **Description**: Cinema Management System

## 📝 Pipeline Stages Explained

Jenkinsfile mới của bạn có các stages:

### 1. **Clone** 
- Pull code từ GitHub

### 2. **Restore Package**
- Download Maven dependencies

### 3. **Build**
- Compile Java code

### 4. **Tests**
- Chạy unit tests

### 5. **Package to JAR**
- Tạo executable JAR file

### 6. **Docker Build** 🆕
- Build Docker image với tags
- Chỉ chạy khi deploy method = docker

### 7. **Docker Test** 🆕  
- Test Docker image với health check
- Chạy container test tạm thời

### 8. **Push to Docker Hub** 🆕
- Push image lên Docker Hub
- Chỉ chạy với branch main/develop

### 9. **Deploy with Docker** 
- Deploy từ Docker Hub image
- Health check với retry logic

### 10. **Notification**
- Hiển thị thông tin deployment

## 🔧 Troubleshooting

### Lỗi thường gặp:

#### 1. Docker permission denied
```bash
# Thêm Jenkins user vào docker group
sudo usermod -a -G docker jenkins
sudo systemctl restart jenkins
```

#### 2. Docker Hub login failed
- Kiểm tra credentials ID đúng: `docker-hub-credentials`
- Verify Docker Hub username/token
- Test login thủ công: `docker login`

#### 3. Build timeout
- Tăng timeout trong Jenkins global config
- Optimize Dockerfile để build nhanh hơn

#### 4. Health check failed
- Kiểm tra application.properties có đúng port không
- Verify database connection string
- Check Docker logs: `docker logs container-name`

## 📊 Monitoring Pipeline

### Jenkins Blue Ocean (Recommended)
1. Install Blue Ocean plugin
2. Access: `http://jenkins-url/blue`
3. Visual pipeline view với logs đẹp

### Pipeline Logs
```bash
# Xem logs real-time
tail -f /var/log/jenkins/jenkins.log

# Docker container logs
docker logs -f container-name
```

## 🎯 Best Practices

### 1. Branch Strategy
- **main**: Production deployments
- **develop**: Staging deployments  
- **feature/***: No deployment, chỉ build + test

### 2. Tagging Strategy
- `latest`: Luôn là main branch
- `{build-number}`: Unique cho mỗi build
- `v1.0.0`: Release tags

### 3. Security
- ✅ Sử dụng Jenkins credentials store
- ✅ Docker Hub access tokens (không dùng password)
- ✅ Scan images for vulnerabilities
- ✅ Run containers as non-root user

### 4. Performance
- Cache Docker layers
- Use multi-stage builds
- Clean up old images/containers

## 🚀 Kết quả mong đợi

Sau khi setup thành công:

1. **Push code** lên GitHub → **Tự động trigger** Jenkins build
2. **Jenkins build** → **Tạo Docker image** → **Push lên Docker Hub**
3. **Deploy** từ Docker Hub → **Application running** tại `http://localhost:8081`
4. **Notifications** về kết quả deployment

## 📞 Support

Nếu gặp vấn đề:
1. Check Jenkins console logs
2. Verify Docker Hub credentials
3. Test Docker commands manually
4. Check GitHub webhook delivery
