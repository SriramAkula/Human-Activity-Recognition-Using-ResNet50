@echo off
echo 🧹 Cleaning up Docker containers...

docker stop flask_app
docker rm flask_app

echo ✅ Cleanup complete.
