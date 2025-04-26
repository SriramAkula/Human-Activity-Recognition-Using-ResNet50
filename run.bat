@echo off
REM Start the container from your image

echo Starting flask-image-classifier container...

docker run -d -p 5000:5000 --name flask-classifier-container flask-image-classifier

echo App should now be accessible at http://localhost:5000

pause
