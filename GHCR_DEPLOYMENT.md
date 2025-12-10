# GitHub Container Registry (GHCR) Deployment Guide

## Prerequisites
1. GitHub account
2. Docker installed and running
3. Personal Access Token (PAT) from GitHub

## Step 1: Create GitHub Personal Access Token

1. Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
   URL: https://github.com/settings/tokens

2. Click "Generate new token (classic)"

3. Give it a name: `GHCR Push Token`

4. Select scopes:
   - ✅ `write:packages` (includes read:packages)
   - ✅ `delete:packages` (optional, for cleanup)
   - ✅ `repo` (if repository is private)

5. Generate token and COPY IT (you'll only see it once!)

## Step 2: Login to GitHub Container Registry

Replace `YOUR_GITHUB_USERNAME` and `YOUR_TOKEN` with your actual values:

```powershell
# Login to GHCR
$env:CR_PAT="YOUR_TOKEN_HERE"
echo $env:CR_PAT | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
```

Example:
```powershell
$env:CR_PAT="ghp_xxxxxxxxxxxxxxxxxxxx"
echo $env:CR_PAT | docker login ghcr.io -u rehan --password-stdin
```

## Step 3: Tag the Docker Image

Replace `YOUR_GITHUB_USERNAME` with your actual GitHub username:

```powershell
docker tag ai-quiz-generator:latest ghcr.io/YOUR_GITHUB_USERNAME/ai-quiz-generator:latest
```

Example:
```powershell
docker tag ai-quiz-generator:latest ghcr.io/rehan/ai-quiz-generator:latest
```

## Step 4: Push to GitHub Container Registry

```powershell
docker push ghcr.io/YOUR_GITHUB_USERNAME/ai-quiz-generator:latest
```

Example:
```powershell
docker push ghcr.io/rehan/ai-quiz-generator:latest
```

## Step 5: Make Package Public (Optional)

1. Go to your GitHub profile → Packages
2. Find `ai-quiz-generator`
3. Click on it → Package settings (at the bottom)
4. Change visibility to Public

## Step 6: Verify

Your image URL will be:
```
ghcr.io/YOUR_GITHUB_USERNAME/ai-quiz-generator:latest
```

Example:
```
ghcr.io/rehan/ai-quiz-generator:latest
```

## Testing the Published Image

Pull and run from GHCR:
```powershell
docker pull ghcr.io/YOUR_GITHUB_USERNAME/ai-quiz-generator:latest
docker run -p 3000:3000 --env-file .env.local ghcr.io/YOUR_GITHUB_USERNAME/ai-quiz-generator:latest
```

## Submission URL Format

Submit this URL:
```
ghcr.io/YOUR_GITHUB_USERNAME/ai-quiz-generator:latest
```

---

## Complete PowerShell Script

Here's the complete script you can run (update YOUR_GITHUB_USERNAME and YOUR_TOKEN):

```powershell
# Set your variables
$GITHUB_USERNAME = "YOUR_GITHUB_USERNAME"
$GITHUB_TOKEN = "YOUR_TOKEN"

# Login to GHCR
$env:CR_PAT = $GITHUB_TOKEN
echo $env:CR_PAT | docker login ghcr.io -u $GITHUB_USERNAME --password-stdin

# Tag the image
docker tag ai-quiz-generator:latest ghcr.io/$GITHUB_USERNAME/ai-quiz-generator:latest

# Push to GHCR
docker push ghcr.io/$GITHUB_USERNAME/ai-quiz-generator:latest

Write-Host "✅ Successfully pushed to GHCR!" -ForegroundColor Green
Write-Host "📦 Your submission URL:" -ForegroundColor Yellow
Write-Host "ghcr.io/$GITHUB_USERNAME/ai-quiz-generator:latest" -ForegroundColor Cyan
```

## Troubleshooting

### "unauthorized: unauthenticated"
- Your token might have expired or lack permissions
- Regenerate token with correct scopes

### "denied: permission_denied"
- Check if your token has `write:packages` scope
- Make sure you're logged in: `docker login ghcr.io`

### Can't find package
- Package visibility might be set to Private
- Change to Public in Package settings on GitHub
