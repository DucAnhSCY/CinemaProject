@echo off
echo Building and starting Cinema Project with Docker...

REM Build and start containers
docker-compose up --build -d

REM Wait for application to start
echo Waiting for application to start...
timeout /t 30 /nobreak

REM Check container status
echo Checking container status...
docker-compose ps

REM Show logs
echo Recent logs:
docker-compose logs --tail=20 cinema-app

REM Test application
echo Testing application health...
curl -f http://localhost:8080/actuator/health 2>nul
if %errorlevel% equ 0 (
    echo.
    echo ✅ Cinema Project is running successfully!
    echo 🌐 Access the application at: http://localhost:8080
) else (
    echo.
    echo ⚠️  Application may still be starting. Check logs with: docker-compose logs cinema-app
)

pause
