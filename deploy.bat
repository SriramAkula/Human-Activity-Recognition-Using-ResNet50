@echo off
echo 🚀 Deploying to Docker Hub...

REM Define DockerHub repo
set IMAGE_NAME=flask-image-classifier
set DOCKERHUB_REPO=sriramakula212/flask-image-classifier

REM Docker login (you can also use secrets instead of plain text)
set /p DOCKER_USER=Enter DockerHub username: 
set /p DOCKER_PASS=Enter DockerHub password: 

echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin

REM Tag and push
docker tag %IMAGE_NAME% %DOCKERHUB_REPO%:latest
docker push %DOCKERHUB_REPO%:latest

if %ERRORLEVEL% neq 0 (
    echo ❌ Push failed!
    exit /b %ERRORLEVEL%
)

echo ✅ Successfully pushed to Docker Hub!
