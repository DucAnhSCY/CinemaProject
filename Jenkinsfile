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
                # Stop existing Java process if running
                try {
                    Get-Process -Name "java" | Where-Object {$_.ProcessName -eq "java"} | Stop-Process -Force
                    Start-Sleep -Seconds 3
                } catch {
                    Write-Host "No existing Java process found"
                }
                
                # Start Spring Boot application
                $jarPath = Get-ChildItem "c:\\deployment\\cinema\\*.jar" | Select-Object -First 1
                if ($jarPath) {
                    Start-Process -FilePath "java" -ArgumentList "-jar $($jarPath.FullName) --server.port=8081" -WindowStyle Hidden
                    Write-Host "Spring Boot application started on port 8081"
                } else {
                    throw "JAR file not found in deployment folder"
                }
                
                # Create IIS website if not exists
                try {
                    Import-Module WebAdministration
                    if (-not (Get-Website -Name "CinemaProject" -ErrorAction SilentlyContinue)) {
                        New-Website -Name "CinemaProject" -Port 8082 -PhysicalPath "c:\\wwwroot\\cinema"
                        Write-Host "IIS Website created on port 8082"
                    } else {
                        Write-Host "IIS Website already exists"
                    }
                } catch {
                    Write-Host "IIS configuration completed with elevated permissions required"
                }
                '''
            }
        } // end deploy

    } // end stages
} // end pipeline
