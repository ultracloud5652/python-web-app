FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy the Flask application code
COPY . .

# Expose the web application port
EXPOSE 80

# Command to run the application
CMD ["python", "app.py"]
