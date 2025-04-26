# Use an official Python image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Copy all necessary files
COPY . . 

# Ensure the model file is copied too
COPY best_model.h5 /app/best_model.h5

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port
EXPOSE 5000

# Run the app
CMD ["python", "app.py"]
