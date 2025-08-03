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
                bat 'xcopy "%WORKSPACE%\\target\\*.jar" /Y "c:\\wwwroot\\cinema-project\\"'
            }
        } // end copy
        
        stage('Deploy to Tomcat/Java Service') {
            steps {
                powershell '''
                # Stop existing Java service if running
                Get-Process -Name "java" -ErrorAction SilentlyContinue | Where-Object {$_.CommandLine -like "*cinema*"} | Stop-Process -Force
                
                # Start new Java application
                Start-Process -FilePath "java" -ArgumentList "-jar","c:\\wwwroot\\cinema-project\\*.jar","--server.port=8090" -WorkingDirectory "c:\\wwwroot\\cinema-project"
                
                # Wait and check if service started
                Start-Sleep -Seconds 10
                try {
                    $response = Invoke-WebRequest -Uri "http://localhost:8090" -TimeoutSec 30
                    Write-Output "Application deployed successfully"
                } catch {
                    Write-Output "Deployment may need manual verification"
                }
                '''
            }
        } // end deploy
        
    } // end stages
} // end pipeline