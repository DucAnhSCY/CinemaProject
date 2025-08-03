@echo off
echo Checking if Cinema Project is running...

REM Test the application
curl -f http://localhost:8081 2>nul
if %errorlevel% equ 0 (
    echo ✅ Cinema Project is running successfully!
    echo 🌐 Access the application at: http://localhost:8081
    echo.
    echo Showing container status:
    docker compose ps
) else (
    echo ❌ Application is not responding on port 8081
    echo.
    echo Checking container status:
    docker compose ps
    echo.
    echo Recent logs:
    docker compose logs --tail=20
)

pause
