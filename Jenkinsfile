pipeline {
    agent any
    
    environment {
        // Docker Hub configuration
        DOCKER_HUB_REGISTRY = 'docker.io'
        DOCKER_IMAGE_NAME = 'ducanhscy/cinema-project'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
        DOCKER_LATEST_TAG = 'latest'
        
        // Deployment configuration
        DEPLOY_METHOD = 'docker'  // 'docker' or 'java'
    }
    
    stages {
        stage('clone') {
            steps {
                echo 'Cloning source code'
                git branch: 'main', url: 'https://github.com/DucAnhSCY/CinemaProject.git'
            }
        } // end clone
        
        stage('restore package') {
            steps {
                echo 'Restore package'
                bat './mvnw.cmd dependency:resolve'
            }
        } // end restore package
        
        stage('build') {
            steps {
                echo 'build project java'
                bat './mvnw.cmd clean compile'
            }
        } // end build
        
        stage('tests') {
            steps {
                echo 'running test...'
                bat './mvnw.cmd test'
            }
        } // end tests
        
        stage('package to jar') {
            steps {
                echo 'Packaging...'
                bat './mvnw.cmd package -DskipTests'
                
                // Archive the JAR file for Docker build
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        } // end package
        
        stage('Docker Build') {
            when {
                anyOf {
                    branch 'main'
                    branch 'develop'
                    expression { env.DEPLOY_METHOD == 'docker' }
                }
            }
            steps {
                echo 'Building Docker image...'
                script {
                    powershell '''
                    Write-Output "🐳 Building Docker image..."
                    
                    # Build Docker image with multiple tags
                    docker build -t $env:DOCKER_IMAGE_NAME:$env:DOCKER_TAG -t $env:DOCKER_IMAGE_NAME:$env:DOCKER_LATEST_TAG .
                    
                    if ($LASTEXITCODE -eq 0) {
                        Write-Output "✅ Docker image built successfully!"
                        
                        # Show image info
                        docker images $env:DOCKER_IMAGE_NAME
                    } else {
                        Write-Error "❌ Docker build failed!"
                        exit 1
                    }
                    '''
                }
            }
        } // end Docker Build
        
        stage('Docker Test') {
            when {
                anyOf {
                    branch 'main'
                    branch 'develop'
                    expression { env.DEPLOY_METHOD == 'docker' }
                }
            }
            steps {
                echo 'Testing Docker image...'
                script {
                    powershell '''
                    Write-Output "🧪 Testing Docker image..."
                    
                    try {
                        # Stop any existing test containers
                        docker stop cinema-test-container -ErrorAction SilentlyContinue
                        docker rm cinema-test-container -ErrorAction SilentlyContinue
                        
                        # Run container for testing
                        Write-Output "Starting test container..."
                        docker run -d --name cinema-test-container -p 8082:8080 `
                            -e SPRING_PROFILES_ACTIVE=test `
                            -e SPRING_DATASOURCE_URL="jdbc:h2:mem:testdb" `
                            -e SPRING_DATASOURCE_DRIVER_CLASS_NAME="org.h2.Driver" `
                            -e SPRING_JPA_DATABASE_PLATFORM="org.hibernate.dialect.H2Dialect" `
                            $env:DOCKER_IMAGE_NAME:$env:DOCKER_TAG
                        
                        # Wait for container to start
                        Write-Output "Waiting for container to start..."
                        Start-Sleep -Seconds 45
                        
                        # Check if container is running
                        $containerStatus = docker ps --filter "name=cinema-test-container" --format "table {{.Status}}"
                        Write-Output "Container status: $containerStatus"
                        
                        # Test health endpoint
                        $maxRetries = 6
                        $retryCount = 0
                        $healthCheckPassed = $false
                        
                        while ($retryCount -lt $maxRetries -and -not $healthCheckPassed) {
                            try {
                                $response = Invoke-WebRequest -Uri "http://localhost:8082/actuator/health" -TimeoutSec 10 -UseBasicParsing
                                if ($response.StatusCode -eq 200) {
                                    Write-Output "✅ Health check passed! Response: $($response.StatusCode)"
                                    $healthCheckPassed = $true
                                }
                            } catch {
                                $retryCount++
                                Write-Output "⏳ Health check attempt $retryCount failed, retrying in 10 seconds..."
                                Start-Sleep -Seconds 10
                            }
                        }
                        
                        if (-not $healthCheckPassed) {
                            Write-Output "❌ Health check failed after $maxRetries attempts"
                            Write-Output "Container logs:"
                            docker logs cinema-test-container --tail 50
                            throw "Health check failed"
                        }
                        
                        Write-Output "✅ Docker image test completed successfully!"
                        
                    } finally {
                        # Cleanup test container
                        Write-Output "Cleaning up test container..."
                        docker stop cinema-test-container -ErrorAction SilentlyContinue
                        docker rm cinema-test-container -ErrorAction SilentlyContinue
                    }
                    '''
                }
            }
        } // end Docker Test
        
        stage('Push to Docker Hub') {
            when {
                anyOf {
                    branch 'main'
                    branch 'develop'
                }
            }
            steps {
                echo 'Pushing to Docker Hub...'
                script {
                    // Use Jenkins credentials for Docker Hub
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-hub-credentials',
                        usernameVariable: 'DOCKER_HUB_USERNAME',
                        passwordVariable: 'DOCKER_HUB_PASSWORD'
                    )]) {
                        powershell '''
                        Write-Output "🚀 Pushing to Docker Hub..."
                        
                        try {
                            # Login to Docker Hub
                            Write-Output "Logging in to Docker Hub..."
                            echo $env:DOCKER_HUB_PASSWORD | docker login $env:DOCKER_HUB_REGISTRY -u $env:DOCKER_HUB_USERNAME --password-stdin
                            
                            if ($LASTEXITCODE -ne 0) {
                                throw "Docker Hub login failed"
                            }
                            
                            # Push both tags
                            Write-Output "Pushing image with build number tag..."
                            docker push $env:DOCKER_IMAGE_NAME:$env:DOCKER_TAG
                            
                            if ($LASTEXITCODE -ne 0) {
                                throw "Failed to push build number tag"
                            }
                            
                            Write-Output "Pushing image with latest tag..."
                            docker push $env:DOCKER_IMAGE_NAME:$env:DOCKER_LATEST_TAG
                            
                            if ($LASTEXITCODE -ne 0) {
                                throw "Failed to push latest tag"
                            }
                            
                            Write-Output "✅ Successfully pushed to Docker Hub!"
                            Write-Output "🐳 Image available at: $env:DOCKER_IMAGE_NAME:$env:DOCKER_TAG"
                            Write-Output "🐳 Latest image: $env:DOCKER_IMAGE_NAME:$env:DOCKER_LATEST_TAG"
                            
                        } catch {
                            Write-Error "❌ Failed to push to Docker Hub: $_"
                            exit 1
                        } finally {
                            # Logout from Docker Hub
                            docker logout $env:DOCKER_HUB_REGISTRY
                        }
                        '''
                    }
                }
            }
        } // end Push to Docker Hub
        
        stage('copy to deploy folder') {
            steps {
                echo 'copy to running folder'
                script {
                    // Tạo thư mục nếu chưa có
                    bat 'if not exist "c:\\wwwroot\\cinema-project" mkdir "c:\\wwwroot\\cinema-project"'
                    
                    // Copy JAR file
                    bat 'xcopy "%WORKSPACE%\\target\\*.jar" /Y "c:\\wwwroot\\cinema-project\\"'
                    
                    // Liệt kê files để kiểm tra
                    bat 'dir "c:\\wwwroot\\cinema-project"'
                    bat 'dir "%WORKSPACE%\\target\\*.jar"'
                }
            }
        } // end copy
        
        stage('Deploy with Docker') {
            steps {
                script {
                    // Kiểm tra deployment method từ environment variable
                    def deployMethod = env.DEPLOY_METHOD ?: 'docker'
                    
                    if (deployMethod == 'docker') {
                        echo 'Deploying with Docker from Docker Hub...'
                        powershell '''
                        Write-Output "🚀 Deploying from Docker Hub..."
                        
                        try {
                            # Pull latest image from Docker Hub (if pushing was successful)
                            if ($env:BRANCH_NAME -eq "main" -or $env:BRANCH_NAME -eq "develop") {
                                Write-Output "Pulling latest image from Docker Hub..."
                                docker pull $env:DOCKER_IMAGE_NAME:$env:DOCKER_LATEST_TAG
                            }
                            
                            # Update docker-compose to use the new image
                            $dockerComposeContent = Get-Content "docker-compose.yml" -Raw
                            $dockerComposeContent = $dockerComposeContent -replace "image: cinema-app:latest", "image: $env:DOCKER_IMAGE_NAME:$env:DOCKER_LATEST_TAG"
                            $dockerComposeContent | Set-Content "docker-compose-prod.yml"
                            
                            # Stop existing containers
                            Write-Output "Stopping existing containers..."
                            docker-compose -f docker-compose-prod.yml down
                            
                            # Start new containers
                            Write-Output "Starting new containers..."
                            docker-compose -f docker-compose-prod.yml up -d
                            
                            # Wait for health check
                            Write-Output "Waiting for application to start..."
                            Start-Sleep -Seconds 60
                            
                            # Check if containers are running
                            Write-Output "Checking container status..."
                            $containers = docker-compose -f docker-compose-prod.yml ps --filter "status=running"
                            Write-Output "Container status: $containers"
                            
                            # Health check with retry
                            $maxRetries = 10
                            $retryCount = 0
                            $deploymentSuccess = $false
                            
                            while ($retryCount -lt $maxRetries -and -not $deploymentSuccess) {
                                try {
                                    $healthCheck = Invoke-WebRequest -Uri "http://localhost:8081/actuator/health" -TimeoutSec 30 -UseBasicParsing
                                    if ($healthCheck.StatusCode -eq 200) {
                                        Write-Output "✅ Docker deployment successful! Health status: $($healthCheck.StatusCode)"
                                        Write-Output "🌐 Application available at: http://localhost:8081"
                                        $deploymentSuccess = $true
                                    }
                                } catch {
                                    $retryCount++
                                    Write-Output "⏳ Health check attempt $retryCount failed, retrying in 15 seconds..."
                                    Start-Sleep -Seconds 15
                                }
                            }
                            
                            if (-not $deploymentSuccess) {
                                Write-Output "⚠️ Health check failed after $maxRetries attempts, checking logs..."
                                docker-compose -f docker-compose-prod.yml logs --tail=20 cinema-app
                                
                                # Still check if container is running
                                $runningContainers = docker-compose -f docker-compose-prod.yml ps --filter "status=running"
                                if ($runningContainers -like "*cinema-app*") {
                                    Write-Output "✅ Container is running, application may still be starting"
                                } else {
                                    Write-Error "❌ Docker deployment failed!"
                                    docker-compose -f docker-compose-prod.yml logs cinema-app
                                    exit 1
                                }
                            }
                            
                        } catch {
                            Write-Error "❌ Deployment failed: $_"
                            Write-Output "Checking container logs..."
                            docker-compose -f docker-compose-prod.yml logs --tail=50 cinema-app
                            exit 1
                        }
                        '''
                    } else {
                        // Legacy deployment method
                        echo 'Deploying with traditional Java service...'
                        powershell '''
                # Kiểm tra JAR file tồn tại
                $jarFiles = Get-ChildItem -Path "c:\\wwwroot\\cinema-project\\*.jar"
                if ($jarFiles.Count -eq 0) {
                    Write-Error "No JAR files found in c:\\wwwroot\\cinema-project\\"
                    exit 1
                }
                
                $jarFile = $jarFiles[0].FullName
                Write-Output "Found JAR file: $jarFile"
                
                # Stop existing Java service if running
                Write-Output "Stopping existing Java processes..."
                Get-Process -Name "java" -ErrorAction SilentlyContinue | Where-Object {$_.CommandLine -like "*cinema*"} | Stop-Process -Force
                Start-Sleep -Seconds 3
                
                # Kiểm tra Java có sẵn không
                try {
                    $javaVersion = java -version 2>&1
                    Write-Output "Java version: $javaVersion"
                } catch {
                    Write-Error "Java not found in PATH"
                    exit 1
                }
                
                # Start new Java application trong background
                Write-Output "Starting Java application: $jarFile"
                $logFile = "c:\\wwwroot\\cinema-project\\app.log"
                
                # Tạo script để chạy ứng dụng
                $startScript = @"
cd c:\\wwwroot\\cinema-project
java -jar "$jarFile" --server.port=8090 > app.log 2>&1
"@
                $startScript | Out-File -FilePath "c:\\wwwroot\\cinema-project\\start.bat" -Encoding ASCII
                
                # Chạy ứng dụng trong background
                Start-Process -FilePath "cmd" -ArgumentList "/c", "c:\\wwwroot\\cinema-project\\start.bat" -WindowStyle Hidden
                
                # Wait and check if service started
                Write-Output "Waiting for application to start..."
                Start-Sleep -Seconds 15
                
                # Kiểm tra process
                $javaProcs = Get-Process -Name "java" -ErrorAction SilentlyContinue
                if ($javaProcs) {
                    Write-Output "Java processes running:"
                    $javaProcs | Format-Table -Property Id, ProcessName, StartTime
                } else {
                    Write-Output "No Java processes found"
                }
                
                # Kiểm tra log file
                if (Test-Path $logFile) {
                    Write-Output "Application log (last 20 lines):"
                    Get-Content $logFile -Tail 20
                }
                
                # Kiểm tra port
                try {
                    $response = Invoke-WebRequest -Uri "http://localhost:8090" -TimeoutSec 30 -UseBasicParsing
                    Write-Output "✅ Application deployed successfully! Status: $($response.StatusCode)"
                } catch {
                    Write-Output "⚠️  Application may still be starting or there is an issue"
                    Write-Output "Error: $($_.Exception.Message)"
                    
                    # Thử kiểm tra với netstat
                    $portCheck = netstat -an | findstr ":8090"
                    if ($portCheck) {
                        Write-Output "Port 8090 is in use: $portCheck"
                    } else {
                        Write-Output "Port 8090 is not in use"
                    }
                }
                '''
                    }
                } // end script
            } // end steps
        } // end deploy
        
        stage('Notification') {
            steps {
                script {
                    echo 'Sending deployment notification...'
                    powershell '''
                    Write-Output "📢 Deployment Summary"
                    Write-Output "===================="
                    Write-Output "🏗️  Build Number: $env:BUILD_NUMBER"
                    Write-Output "🌿 Branch: $($env:BRANCH_NAME ?? 'main')"
                    Write-Output "🐳 Docker Image: $env:DOCKER_IMAGE_NAME:$env:DOCKER_TAG"
                    Write-Output "📦 Latest Image: $env:DOCKER_IMAGE_NAME:$env:DOCKER_LATEST_TAG"
                    Write-Output "🌐 Application URL: http://localhost:8081"
                    Write-Output "💚 Deployment Method: $env:DEPLOY_METHOD"
                    Write-Output "✅ Pipeline completed successfully!"
                    Write-Output "===================="
                    
                    # Show running containers
                    Write-Output "🐳 Running Containers:"
                    docker ps --filter "name=cinema" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
                    '''
                }
            }
        } // end notification

    } // end stages
    
    post {
        always {
            echo 'Pipeline completed!'
            
            // Clean up workspace
            script {
                powershell '''
                Write-Output "🧹 Cleaning up..."
                
                # Remove old Docker images (keep last 3 builds)
                try {
                    $oldImages = docker images $env:DOCKER_IMAGE_NAME --format "{{.Tag}}" | Where-Object {$_ -match "^\\d+$"} | Sort-Object {[int]$_} | Select-Object -SkipLast 3
                    if ($oldImages) {
                        Write-Output "Removing old Docker images: $($oldImages -join ', ')"
                        foreach ($tag in $oldImages) {
                            docker rmi "$env:DOCKER_IMAGE_NAME:$tag" -ErrorAction SilentlyContinue
                        }
                    }
                } catch {
                    Write-Output "Warning: Could not clean old images: $_"
                }
                
                # Clean up dangling images
                $danglingImages = docker images -f "dangling=true" -q
                if ($danglingImages) {
                    Write-Output "Removing dangling images..."
                    docker rmi $danglingImages -ErrorAction SilentlyContinue
                }
                '''
            }
        }
        
        success {
            echo '✅ Pipeline succeeded!'
            script {
                powershell '''
                Write-Output "🎉 SUCCESS! Cinema Project deployed successfully!"
                Write-Output "🔗 Access your application at: http://localhost:8081"
                Write-Output "📊 Health check: http://localhost:8081/actuator/health"
                '''
            }
        }
        
        failure {
            echo '❌ Pipeline failed!'
            script {
                powershell '''
                Write-Output "💥 FAILURE! Pipeline failed during execution"
                Write-Output "📋 Check the logs above for error details"
                Write-Output "🐳 Container logs (if available):"
                docker-compose -f docker-compose-prod.yml logs --tail=20 cinema-app -ErrorAction SilentlyContinue
                '''
            }
        }
        
        unstable {
            echo '⚠️ Pipeline unstable!'
        }
    } // end post

} // end pipeline