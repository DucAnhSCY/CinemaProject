pipeline {
    agent any
    
    tools {
        maven 'Maven-3.9.0' // Đảm bảo Maven đã được cấu hình trong Jenkins Global Tool Configuration
        jdk 'JDK-17' // Đảm bảo JDK đã được cấu hình trong Jenkins Global Tool Configuration
    }
    
    stages {
        stage('Clone') {
            steps {
                echo 'Cloning source code'
                git branch: 'main', url: 'https://github.com/DucAnhSCY/CinemaProject.git'
            }
        } // end clone
        
        stage('Clean & Compile') {
            steps {
                echo 'Cleaning and compiling project'
                bat 'mvn clean compile'
            }
        } // end clean & compile
        
        stage('Test') {
            steps {
                echo 'Running tests...'
                bat 'mvn test'
            }
            post {
                always {
                    // Lưu kết quả test
                    publishTestResults testResultsPattern: 'target/surefire-reports/*.xml'
                    // Lưu coverage report nếu có
                    publishCoverage adapters: [jacocoAdapter('target/site/jacoco/jacoco.xml')], sourceFileResolver: sourceFiles('STORE_LAST_BUILD')
                }
            }
        } // end test
        
        stage('Package') {
            steps {
                echo 'Packaging application...'
                bat 'mvn package -DskipTests'
            }
        } // end package
        
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                script {
                    // Tạo Dockerfile nếu chưa có
                    if (!fileExists('Dockerfile')) {
                        writeFile file: 'Dockerfile', text: '''
FROM openjdk:17-jre-slim
VOLUME /tmp
COPY target/*.jar app.jar
EXPOSE 8090
ENTRYPOINT ["java","-jar","/app.jar","--server.port=8090"]
'''
                    }
                    // Build Docker image
                    bat 'docker build -t cinema-project:latest .'
                }
            }
        } // end docker build
        
        stage('Deploy to Test Environment') {
            steps {
                echo 'Deploying to test environment...'
                script {
                    // Stop existing container if running
                    bat 'docker stop cinema-test || echo "No container to stop"'
                    bat 'docker rm cinema-test || echo "No container to remove"'
                    
                    // Run new container
                    bat 'docker run -d --name cinema-test -p 8090:8090 cinema-project:latest'
                }
            }
        } // end deploy test
        
        stage('Health Check') {
            steps {
                echo 'Performing health check...'
                script {
                    // Wait for application to start
                    sleep(30)
                    
                    // Simple health check
                    bat '''
                        curl -f http://localhost:8090/actuator/health || (
                            echo "Health check failed"
                            docker logs cinema-test
                            exit 1
                        )
                    '''
                }
            }
        } // end health check
        
        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                echo 'Deploying to production...'
                script {
                    // Copy JAR file to production directory
                    bat 'xcopy "%WORKSPACE%\\target\\*.jar" /Y "C:\\cinema-production\\"'
                    
                    // Restart production service (adjust according to your setup)
                    bat '''
                        net stop "CinemaService" || echo "Service not running"
                        timeout /t 5
                        net start "CinemaService" || echo "Failed to start service"
                    '''
                }
            }
        } // end deploy production
        
    } // end stages
    
    post {
        always {
            // Clean workspace
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
            // Send success notification
            emailext (
                subject: "Jenkins Build SUCCESS: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
                body: "Build completed successfully. Check console output at ${env.BUILD_URL}",
                to: "your-email@domain.com"
            )
        }
        failure {
            echo 'Pipeline failed!'
            // Send failure notification
            emailext (
                subject: "Jenkins Build FAILED: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
                body: "Build failed. Check console output at ${env.BUILD_URL}",
                to: "your-email@domain.com"
            )
        }
    }
} // end pipeline