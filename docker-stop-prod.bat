@echo off
echo ======================================
echo   Stopping Cinema Project (Production)
echo ======================================

echo Stopping Cinema application containers...
docker-compose -f docker-compose.prod.yml down

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Cinema Project stopped successfully!
    echo.
    echo Checking remaining containers...
    docker ps --filter "name=cinema"
    echo.
    echo To remove all images and volumes, run:
    echo docker system prune -f
    echo docker volume prune -f
    echo.
) else (
    echo Failed to stop some containers!
    echo You may need to stop them manually.
)

pause
