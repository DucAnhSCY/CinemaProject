@echo off
echo =====================================
echo   Cinema Project - Update Check
echo =====================================

set IMAGE_NAME=ducanhscy/cinema-project:latest

echo Checking for updates on Docker Hub...
docker pull %IMAGE_NAME%

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Image updated successfully!
    echo.
    
    set /p RESTART_CONFIRM="Do you want to restart the application with the new image? (y/n): "
    if /i "!RESTART_CONFIRM!" EQU "y" (
        echo.
        echo Restarting application...
        
        echo Stopping current container...
        docker-compose -f docker-compose.prod.yml down
        
        echo Starting with updated image...
        docker-compose -f docker-compose.prod.yml up -d
        
        echo.
        echo Application restarted with latest image!
        echo Check status: docker ps --filter "name=cinema-app-prod"
    ) else (
        echo Update complete. Restart manually when ready.
    )
) else (
    echo Failed to check for updates!
    echo Check your internet connection.
)

pause
