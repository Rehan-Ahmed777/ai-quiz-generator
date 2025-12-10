# Quick Docker build and test script for Windows

Write-Host "🐳 Building Docker image..." -ForegroundColor Cyan
docker build -t ai-quiz-generator:local .

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Build successful!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🚀 To run the container:" -ForegroundColor Yellow
    Write-Host "   docker run -p 3000:3000 --env-file .env.local ai-quiz-generator:local"
    Write-Host ""
    Write-Host "📦 To run with docker-compose:" -ForegroundColor Yellow
    Write-Host "   docker-compose up"
} else {
    Write-Host "❌ Build failed!" -ForegroundColor Red
    exit 1
}
