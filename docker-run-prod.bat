@echo off
echo ====================================
echo   Cinema Project - Docker Hub Run
echo ====================================

echo Pulling latest image from Docker Hub...
docker pull ducanhscy/cinema-project:latest

if %ERRORLEVEL% NEQ 0 (
    echo Failed to pull image from Docker Hub!
    echo Make sure you have internet connection and the image exists.
    pause
    exit /b 1
)

echo Starting Cinema application from Docker Hub...
docker-compose -f docker-compose.prod.yml up -d

if %ERRORLEVEL% EQU 0 (
    echo.
    echo =====================================
    echo   Cinema Project is starting up...
    echo =====================================
    echo.
    echo Application will be available at: http://localhost:8081
    echo.
    echo Checking container status...
    timeout /t 5 >nul
    docker ps --filter "name=cinema-app-prod"
    echo.
    echo Use "docker logs cinema-app-prod -f" to see application logs
    echo Use "docker-stop-prod.bat" to stop the application
    echo.
) else (
    echo Failed to start Cinema application!
    echo Check Docker logs for more information.
)

pause
