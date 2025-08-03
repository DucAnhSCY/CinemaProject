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

        stage('package application') {
            steps {
                echo 'Packaging application...'
                bat 'mvn package'
            }
        } // end package

        stage('copy to deployment folder') {
            steps {
                echo 'Copying JAR file to deployment folder'
                bat 'if not exist "c:\\deployment\\cinema" mkdir "c:\\deployment\\cinema"'
                bat 'copy "%WORKSPACE%\\target\\*.jar" "c:\\deployment\\cinema\\"'
            }
        } // end copy

        stage('Deploy to IIS with Domain') {
            steps {
                echo 'Deploying Spring Boot application to hexaspace.tech'
                powershell '''
                # Stop existing Java process if running
                try {
                    Get-Process -Name "java" | Where-Object {$_.CommandLine -like "*CinemaProject*"} | Stop-Process -Force
                    Start-Sleep -Seconds 3
                } catch {
                    Write-Host "No existing Java process found"
                }
                
                # Start Spring Boot application as background service
                $jarPath = Get-ChildItem "c:\\deployment\\cinema\\*.jar" | Select-Object -First 1
                if ($jarPath) {
                    Start-Process -FilePath "java" -ArgumentList "-jar $($jarPath.FullName) --server.port=8080 --server.address=0.0.0.0" -WindowStyle Hidden
                    Write-Host "Spring Boot application started on port 8080"
                } else {
                    throw "JAR file not found in deployment folder"
                }
                
                # Setup IIS website for hexaspace.tech domain
                Import-Module WebAdministration
                
                # Remove existing site if exists
                if (Get-Website -Name "CinemaProject" -ErrorAction SilentlyContinue) {
                    Remove-Website -Name "CinemaProject"
                }
                
                # Create physical directory for the site
                $sitePath = "c:\\inetpub\\wwwroot\\cinema"
                if (-not (Test-Path $sitePath)) {
                    New-Item -ItemType Directory -Path $sitePath -Force
                }
                
                # Create web.config for reverse proxy
                $webConfig = @"
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <system.webServer>
        <rewrite>
            <rules>
                <rule name="ReverseProxyInboundRule1" stopProcessing="true">
                    <match url="(.*)" />
                    <action type="Rewrite" url="http://localhost:8080/{R:1}" />
                </rule>
            </rules>
        </rewrite>
    </system.webServer>
</configuration>
"@
                
                Set-Content -Path "$sitePath\\web.config" -Value $webConfig
                
                # Create new website with domain binding
                New-Website -Name "CinemaProject" -Port 80 -PhysicalPath $sitePath -HostHeader "hexaspace.tech"
                
                # Add www subdomain binding
                New-WebBinding -Name "CinemaProject" -IPAddress "*" -Port 80 -HostHeader "www.hexaspace.tech"
                
                # Optional: Add HTTPS bindings if you have SSL certificate
                # New-WebBinding -Name "CinemaProject" -IPAddress "*" -Port 443 -HostHeader "hexaspace.tech" -Protocol "https"
                # New-WebBinding -Name "CinemaProject" -IPAddress "*" -Port 443 -HostHeader "www.hexaspace.tech" -Protocol "https"
                
                Write-Host "Website configured for hexaspace.tech domain"
                '''
            }
        } // end deploy

    } // end stages
} // end pipeline
//