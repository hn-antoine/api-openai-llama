# api-openai-llama

Building and Running the Docker Container

Build the Docker Image: Run this command in the same directory as the Dockerfile, requirements.txt, and app.py:

docker build -t local-chatgpt-server .


Run the Docker Container:

docker run -p 8000:8000 local-chatgpt-server

Test the API Endpoint:

After running the container, you can test the endpoint:

curl -X POST "http://127.0.0.1:8000/chat" -H "Content-Type: application/json" -d '{"prompt": "Hello, how are you?", "max_length": 50}'

This Docker setup allows you to have a self-contained environment with all dependencies, making it easier to deploy your local OpenAI-style chat server across different machines.
