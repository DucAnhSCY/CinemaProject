@echo off
echo Stopping Cinema Project containers...

REM Stop and remove containers
docker-compose down

REM Optional: Remove images (uncomment if needed)
REM docker rmi cinema-app:latest

echo Cinema Project containers stopped.
pause
