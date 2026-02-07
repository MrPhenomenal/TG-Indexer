# Use a slim Python image to keep the build light
FROM python:3.10-slim-buster

# Set environment variables to prevent Python from writing .pyc files and buffering output
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory
WORKDIR /app

# Install system dependencies (often needed for Telegram libraries or crypto)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy only the requirements first to leverage Docker cache
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Expose the port the app runs on (usually 8080 or defined by PORT env var)
EXPOSE 8080

# Command to run the application
# Note: Check if your entry file is 'main.py' or 'app.py' and adjust accordingly
CMD ["python3", "app.py"]
