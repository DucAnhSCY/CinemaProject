pipeline {
    agent any
    
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
            }
        } // end package
        
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
        
        stage('Deploy to Tomcat/Java Service') {
            steps {
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
        } // end deploy
        
    } // end stages
} // end pipeline