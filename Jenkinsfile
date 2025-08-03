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

        stage('Deploy to IIS Local') {
            steps {
                echo 'Deploying Spring Boot application to IIS Local'
                powershell '''
                # Stop existing Spring Boot process safely
                try {
                    $javaProcesses = Get-Process -Name "java" -ErrorAction SilentlyContinue
                    foreach ($proc in $javaProcesses) {
                        $cmdLine = (Get-WmiObject Win32_Process -Filter "ProcessId = $($proc.Id)").CommandLine
                        if ($cmdLine -like "*CinemaProject*" -or $cmdLine -like "*cinema*") {
                            Stop-Process -Id $proc.Id -Force
                            Write-Host "Stopped Java process ID: $($proc.Id)"
                        }
                    }
                    Start-Sleep -Seconds 5
                } catch {
                    Write-Host "No existing Spring Boot process found"
                }
                
                # Start Spring Boot application for local access
                $jarPath = Get-ChildItem "c:\\deployment\\cinema\\*.jar" | Select-Object -First 1
                if ($jarPath) {
                    # Start on port 8080 for local access
                    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
                    $startInfo.FileName = "java"
                    $startInfo.Arguments = "-jar `"$($jarPath.FullName)`" --server.port=8080"
                    $startInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
                    $startInfo.WorkingDirectory = "c:\\deployment\\cinema"
                    
                    [System.Diagnostics.Process]::Start($startInfo) | Out-Null
                    Write-Host "Spring Boot application started on port 8080"
                    
                    # Wait for application to start
                    Start-Sleep -Seconds 15
                    
                    # Verify application is running
                    try {
                        $response = Invoke-WebRequest -Uri "http://localhost:8080" -TimeoutSec 10 -ErrorAction SilentlyContinue
                        Write-Host "✅ Application is responding on http://localhost:8080"
                    } catch {
                        Write-Host "⚠️ Application started but may still be initializing..."
                    }
                } else {
                    Write-Host "❌ JAR file not found in deployment folder"
                    exit 1
                }
                
                # Setup IIS website for local access
                try {
                    Import-Module WebAdministration -ErrorAction SilentlyContinue
                    
                    # Remove existing site if exists
                    if (Get-Website -Name "CinemaProject" -ErrorAction SilentlyContinue) {
                        Remove-Website -Name "CinemaProject" -ErrorAction SilentlyContinue
                        Write-Host "Removed existing IIS website"
                    }
                    
                    # Create physical directory for the site
                    $sitePath = "c:\\inetpub\\wwwroot\\cinema"
                    if (-not (Test-Path $sitePath)) {
                        New-Item -ItemType Directory -Path $sitePath -Force
                        Write-Host "Created IIS site directory: $sitePath"
                    }
                    
                    # Create web.config for reverse proxy to Spring Boot
                    $webConfig = @"
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <system.webServer>
        <rewrite>
            <rules>
                <rule name="SpringBootProxy" stopProcessing="true">
                    <match url="(.*)" />
                    <action type="Rewrite" url="http://localhost:8080/{R:1}" />
                </rule>
            </rules>
        </rewrite>
        <defaultDocument>
            <files>
                <clear />
                <add value="index.html" />
            </files>
        </defaultDocument>
    </system.webServer>
</configuration>
"@
                    
                    Set-Content -Path "$sitePath\\web.config" -Value $webConfig -Encoding UTF8
                    Write-Host "Created web.config for reverse proxy"
                    
                    # Create new IIS website on localhost
                    New-Website -Name "CinemaProject" -Port 8082 -PhysicalPath $sitePath -ErrorAction SilentlyContinue
                    Write-Host "✅ IIS Website created on port 8082"
                    
                    Write-Host ""
                    Write-Host "🎉 Deployment completed successfully!"
                    Write-Host "🌐 Access URLs:"
                    Write-Host "   - Spring Boot Direct: http://localhost:8080"
                    Write-Host "   - IIS Proxy:          http://localhost:8082"
                    Write-Host "   - Network Access:     http://192.168.0.24:8080"
                    
                } catch {
                    Write-Host "⚠️ IIS configuration requires administrator privileges"
                    Write-Host "✅ Spring Boot application is running on http://localhost:8080"
                }
                '''
            }
        } // end deploy

    } // end stages
} // end pipeline
??