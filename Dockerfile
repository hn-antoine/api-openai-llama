# Use an official Python image as the base image
FROM python:3.8-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV MODEL_NAME="EleutherAI/gpt-neo-2.7B"  # Adjust if you want a different model

# Install system dependencies and create app directory
RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the requirements and install them
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY . .

# Download the model at build time to speed up runtime start
RUN python -c "from transformers import AutoModelForCausalLM, AutoTokenizer; \
               tokenizer = AutoTokenizer.from_pretrained('$MODEL_NAME'); \
               model = AutoModelForCausalLM.from_pretrained('$MODEL_NAME')"

# Expose the port the app will run on
EXPOSE 8000

# Command to run the FastAPI server with Uvicorn
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]

