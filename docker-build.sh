#!/bin/bash
# Quick Docker build and test script

echo "🐳 Building Docker image..."
docker build -t ai-quiz-generator:local .

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo ""
    echo "🚀 To run the container:"
    echo "   docker run -p 3000:3000 --env-file .env.local ai-quiz-generator:local"
    echo ""
    echo "📦 To run with docker-compose:"
    echo "   docker-compose up"
else
    echo "❌ Build failed!"
    exit 1
fi
