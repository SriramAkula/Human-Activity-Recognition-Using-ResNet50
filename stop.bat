@echo off
REM Stop and remove the container if it's already running

echo Stopping and removing existing container...

docker stop flask-classifier-container
docker rm flask-classifier-container

pause
