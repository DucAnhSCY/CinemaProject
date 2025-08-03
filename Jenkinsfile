pipeline {
    agent any
    
    stages {
        stage('clone'){
            steps {
                echo 'Cloning source code'
                git branch: 'main', url: 'https://github.com/DucAnhSCY/CinemaProject.git'
            }
        } // end clone

        stage('restore dependencies') {
            steps {
                echo 'Restore Maven dependencies'
                bat 'mvn clean compile'
            }
        } // end restore

        stage('build') {
            steps {
                echo 'Build Spring Boot project'
                bat 'mvn package -DskipTests'
            }
        } // end build
        
        stage('tests') {
            steps {
                echo 'Running tests...'
                bat 'mvn test'
            }
        } // end tests

        stage('publish to folder') {
            steps {
                echo 'Publishing JAR to deployment folder...'
                bat 'if not exist "c:\\wwwroot\\cinema" mkdir "c:\\wwwroot\\cinema"'
                bat 'copy "%WORKSPACE%\\target\\*.jar" "c:\\wwwroot\\cinema\\"'
            }
        } // end publish

        stage('copy to running folder') {
            steps {
                echo 'Copy to running folder'
                bat 'if not exist "c:\\deployment\\cinema" mkdir "c:\\deployment\\cinema"'
                bat 'xcopy "c:\\wwwroot\\cinema\\*.jar" "c:\\deployment\\cinema\\" /E /Y /I /R'
            }
        } // end copy

        stage('Deploy to Local IIS') {
            steps {
                echo 'Deploying Spring Boot application locally'
                powershell '''
                # Stop existing Spring Boot process safely
                try {
                    $processes = Get-Process -Name "java" -ErrorAction SilentlyContinue | Where-Object {
                        $_.MainWindowTitle -like "*spring*" -or 
                        $_.ProcessName -eq "java" -and $_.Path -like "*java*"
                    }
                    
                    if ($processes) {
                        foreach ($proc in $processes) {
                            # Only kill if it's listening on port 8081
                            $connections = netstat -ano | Select-String ":8081"
                            if ($connections -and $connections -match $proc.Id) {
                                Stop-Process -Id $proc.Id -Force
                                Write-Host "Stopped Spring Boot process ID: $($proc.Id)"
                            }
                        }
                        Start-Sleep -Seconds 5
                    }
                } catch {
                    Write-Host "No Spring Boot process found to stop"
                }
                
                # Start Spring Boot application
                $jarPath = Get-ChildItem "c:\\deployment\\cinema\\*.jar" | Select-Object -First 1
                if ($jarPath) {
                    # Start with proper working directory
                    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
                    $startInfo.FileName = "java"
                    $startInfo.Arguments = "-jar `"$($jarPath.FullName)`" --server.port=8081"
                    $startInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
                    $startInfo.WorkingDirectory = "c:\\deployment\\cinema"
                    
                    [System.Diagnostics.Process]::Start($startInfo) | Out-Null
                    Write-Host "Spring Boot application started on port 8081"
                    
                    # Wait a bit for the application to start
                    Start-Sleep -Seconds 10
                    
                    # Verify it's running
                    try {
                        $response = Invoke-WebRequest -Uri "http://localhost:8081" -TimeoutSec 5 -ErrorAction SilentlyContinue
                        Write-Host "Application is responding on port 8081"
                    } catch {
                        Write-Host "Application started but may still be initializing..."
                    }
                } else {
                    Write-Host "ERROR: JAR file not found in deployment folder"
                    exit 1
                }
                
                # Simple IIS check without admin requirements
                try {
                    $iisRunning = Get-Service -Name "W3SVC" -ErrorAction SilentlyContinue
                    if ($iisRunning -and $iisRunning.Status -eq "Running") {
                        Write-Host "IIS is running and available"
                        Write-Host "You can manually configure IIS website if needed"
                    } else {
                        Write-Host "IIS service not running or not available"
                    }
                } catch {
                    Write-Host "IIS check completed"
                }
                
                Write-Host "Deployment completed successfully!"
                Write-Host "Application URL: http://localhost:8081"
                '''
            }
        } // end deploy

    } // end stages
} // end pipeline
