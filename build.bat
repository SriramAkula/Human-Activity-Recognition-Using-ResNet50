@echo off
echo 🚧 Building Docker image...

REM Define image name
set IMAGE_NAME=flask-image-classifier

REM Build Docker image
docker build -t %IMAGE_NAME% .

if %ERRORLEVEL% neq 0 (
    echo ❌ Build failed!
    exit /b %ERRORLEVEL%
)

echo ✅ Docker image built successfully!

REM Run container locally
echo ▶️ Running container on port 5000...
docker run -d -p 5000:5000 --name flask_app %IMAGE_NAME%

echo 🌐 App should now be accessible at http://localhost:5000
