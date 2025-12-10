# PowerShell script to push to GitHub Container Registry
# Update these variables with your information

param(
    [Parameter(Mandatory=$true)]
    [string]$GitHubUsername,
    
    [Parameter(Mandatory=$true)]
    [string]$GitHubToken
)

Write-Host "🚀 Starting GHCR deployment process..." -ForegroundColor Cyan

# Login to GHCR
Write-Host "🔐 Logging in to GitHub Container Registry..." -ForegroundColor Yellow
$env:CR_PAT = $GitHubToken
$loginResult = echo $env:CR_PAT | docker login ghcr.io -u $GitHubUsername --password-stdin

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Login failed! Please check your credentials." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Login successful!" -ForegroundColor Green

# Tag the image
Write-Host "🏷️  Tagging image..." -ForegroundColor Yellow
$imageName = "ghcr.io/$GitHubUsername/ai-quiz-generator:latest"
docker tag ai-quiz-generator:latest $imageName

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Tagging failed!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Image tagged successfully!" -ForegroundColor Green

# Push to GHCR
Write-Host "📤 Pushing to GitHub Container Registry..." -ForegroundColor Yellow
docker push $imageName

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Push failed!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🎉 Successfully deployed to GHCR!" -ForegroundColor Green
Write-Host ""
Write-Host "📦 Your submission URL:" -ForegroundColor Yellow
Write-Host $imageName -ForegroundColor Cyan
Write-Host ""
Write-Host "💡 Next steps:" -ForegroundColor Yellow
Write-Host "1. Go to https://github.com/$GitHubUsername?tab=packages" -ForegroundColor White
Write-Host "2. Find 'ai-quiz-generator' package" -ForegroundColor White
Write-Host "3. Make it public if needed (Package settings)" -ForegroundColor White
Write-Host ""
Write-Host "✅ Submit this URL: $imageName" -ForegroundColor Green
