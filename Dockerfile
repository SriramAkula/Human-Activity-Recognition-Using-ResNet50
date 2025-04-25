# Base image with TensorFlow pre-installed
FROM tensorflow/tensorflow:2.15.0 as base

# Set working directory
WORKDIR /app

# Copy only requirements first (for better caching)
COPY requirements.txt .

# Install additional dependencies (TensorFlow is already installed)
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Expose the port Flask will use
EXPOSE 5000

# Run the app
CMD ["python", "app.py"]
