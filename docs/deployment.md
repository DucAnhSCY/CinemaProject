# 🚀 Deployment Guide

Hướng dẫn deploy Cinema Project lên các môi trường khác nhau.

## 📦 Deploy với Docker Hub

### 1. Production Server Setup

```bash
# Tải docker-compose production file
wget https://raw.githubusercontent.com/DucAnhSCY/CinemaProject/main/docker-compose.prod.yml

# Chạy ứng dụng
docker-compose -f docker-compose.prod.yml up -d

# Kiểm tra logs
docker logs cinema-app-prod -f
```

### 2. Cloud Platforms

#### AWS ECS
```yaml
# task-definition.json
{
  "family": "cinema-project",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "1024",
  "memory": "2048",
  "executionRoleArn": "arn:aws:iam::ACCOUNT:role/ecsTaskExecutionRole",
  "containerDefinitions": [
    {
      "name": "cinema-app",
      "image": "ducanh/cinema-project:latest",
      "portMappings": [
        {
          "containerPort": 8080,
          "protocol": "tcp"
        }
      ],
      "environment": [
        {
          "name": "SPRING_PROFILES_ACTIVE",
          "value": "docker"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/cinema-project",
          "awslogs-region": "us-west-2",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
}
```

#### Google Cloud Run
```bash
# Deploy to Cloud Run
gcloud run deploy cinema-project \
  --image=ducanh/cinema-project:latest \
  --platform=managed \
  --region=us-central1 \
  --allow-unauthenticated \
  --port=8080 \
  --memory=2Gi \
  --set-env-vars="SPRING_PROFILES_ACTIVE=docker"
```

#### Azure Container Instances
```bash
# Deploy to Azure
az container create \
  --resource-group myResourceGroup \
  --name cinema-project \
  --image ducanh/cinema-project:latest \
  --cpu 1 \
  --memory 2 \
  --ports 8080 \
  --environment-variables SPRING_PROFILES_ACTIVE=docker
```

## 🔄 CI/CD Pipeline

### GitHub Actions (Đã setup)
Pipeline tự động build và push khi:
- Push code lên `main` hoặc `develop`
- Tạo tag release (v1.0.0, v1.1.0, etc.)

### Jenkins Pipeline
```groovy
pipeline {
    agent any
    
    environment {
        DOCKER_HUB_CREDS = credentials('docker-hub-credentials')
        IMAGE_NAME = 'ducanh/cinema-project'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                script {
                    def app = docker.build("${IMAGE_NAME}:${env.BUILD_ID}")
                }
            }
        }
        
        stage('Test') {
            steps {
                sh 'docker run --rm ${IMAGE_NAME}:${env.BUILD_ID} java -jar app.jar --spring.profiles.active=test'
            }
        }
        
        stage('Push') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        def app = docker.image("${IMAGE_NAME}:${env.BUILD_ID}")
                        app.push()
                        app.push("latest")
                    }
                }
            }
        }
        
        stage('Deploy') {
            steps {
                sh '''
                    docker-compose -f docker-compose.prod.yml down
                    docker-compose -f docker-compose.prod.yml pull
                    docker-compose -f docker-compose.prod.yml up -d
                '''
            }
        }
    }
}
```

## 🌐 Kubernetes Deployment

### Deployment YAML
```yaml
# k8s-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cinema-project
  labels:
    app: cinema-project
spec:
  replicas: 3
  selector:
    matchLabels:
      app: cinema-project
  template:
    metadata:
      labels:
        app: cinema-project
    spec:
      containers:
      - name: cinema-project
        image: ducanh/cinema-project:latest
        ports:
        - containerPort: 8080
        env:
        - name: SPRING_PROFILES_ACTIVE
          value: "docker"
        - name: SPRING_DATASOURCE_URL
          valueFrom:
            secretKeyRef:
              name: cinema-db-secret
              key: database-url
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /actuator/health
            port: 8080
          initialDelaySeconds: 60
          periodSeconds: 30
        readinessProbe:
          httpGet:
            path: /actuator/health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
---
apiVersion: v1
kind: Service
metadata:
  name: cinema-project-service
spec:
  selector:
    app: cinema-project
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: LoadBalancer
```

### Apply Kubernetes
```bash
kubectl apply -f k8s-deployment.yaml
kubectl get pods -l app=cinema-project
kubectl get services
```

## 🔒 Security & Monitoring

### Environment Variables
Luôn sử dụng secrets cho production:

```bash
# Docker Secrets
echo "your-db-password" | docker secret create db_password -

# Kubernetes Secrets
kubectl create secret generic cinema-db-secret \
  --from-literal=database-url="jdbc:sqlserver://..." \
  --from-literal=database-username="..." \
  --from-literal=database-password="..."
```

### Monitoring
```yaml
# Prometheus monitoring
version: '3.8'
services:
  cinema-app:
    image: ducanh/cinema-project:latest
    environment:
      - MANAGEMENT_ENDPOINTS_WEB_EXPOSURE_INCLUDE=health,info,metrics,prometheus
    
  prometheus:
    image: prom/prometheus
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"
    
  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"
```

## 📈 Scaling

### Docker Swarm
```bash
# Initialize swarm
docker swarm init

# Deploy stack
docker stack deploy -c docker-compose.prod.yml cinema

# Scale service
docker service scale cinema_cinema-app=3
```

### Load Balancer (Nginx)
```nginx
upstream cinema_backend {
    server cinema-app-1:8080;
    server cinema-app-2:8080;
    server cinema-app-3:8080;
}

server {
    listen 80;
    server_name cinema.example.com;
    
    location / {
        proxy_pass http://cinema_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## 🔧 Troubleshooting

### Common Issues

1. **Container không start**
   ```bash
   docker logs cinema-app-prod
   docker inspect cinema-app-prod
   ```

2. **Database connection issues**
   ```bash
   # Test database connectivity
   docker run --rm -it ducanh/cinema-project:latest sh
   telnet your-db-host 1433
   ```

3. **Memory issues**
   ```bash
   # Monitor resource usage
   docker stats cinema-app-prod
   
   # Adjust memory limits
   docker update --memory=2g cinema-app-prod
   ```

### Health Checks
```bash
# Application health
curl http://localhost:8081/actuator/health

# Detailed metrics
curl http://localhost:8081/actuator/metrics

# Application info
curl http://localhost:8081/actuator/info
```

## 📞 Support

Nếu gặp vấn đề trong quá trình deployment:

1. Kiểm tra logs: `docker logs cinema-app-prod -f`
2. Kiểm tra health check: `curl http://localhost:8081/actuator/health`
3. Tạo issue trên GitHub: [Issues](https://github.com/DucAnhSCY/CinemaProject/issues)
4. Liên hệ team qua email hoặc Slack
