@echo off
setlocal enabledelayedexpansion

echo =====================================
echo   Build and Push to Docker Hub
echo =====================================

set IMAGE_NAME=ducanhscy/cinema-project
set VERSION=latest

echo Building Docker image...
docker build -t %IMAGE_NAME%:%VERSION% .

if %ERRORLEVEL% NEQ 0 (
    echo Failed to build Docker image!
    pause
    exit /b 1
)

echo.
echo Docker image built successfully!
echo Image: %IMAGE_NAME%:%VERSION%
echo.

set /p PUSH_CONFIRM="Do you want to push to Docker Hub? (y/n): "
if /i "!PUSH_CONFIRM!" NEQ "y" (
    echo Push cancelled.
    pause
    exit /b 0
)

echo.
echo Logging in to Docker Hub...
echo Please enter your Docker Hub credentials:
docker login

if %ERRORLEVEL% NEQ 0 (
    echo Failed to login to Docker Hub!
    pause
    exit /b 1
)

echo.
echo Pushing image to Docker Hub...
docker push %IMAGE_NAME%:%VERSION%

if %ERRORLEVEL% EQU 0 (
    echo.
    echo =====================================
    echo   Push Successful!
    echo =====================================
    echo.
    echo Image pushed to: %IMAGE_NAME%:%VERSION%
    echo.
    echo You can now pull and run this image anywhere with:
    echo docker pull %IMAGE_NAME%:%VERSION%
    echo docker run -p 8081:8080 %IMAGE_NAME%:%VERSION%
    echo.
    echo Or use the production docker-compose:
    echo docker-compose -f docker-compose.prod.yml up -d
    echo.
) else (
    echo Failed to push image to Docker Hub!
    echo Check your internet connection and Docker Hub credentials.
)

pause
