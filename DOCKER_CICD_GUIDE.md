# Docker and CI/CD Setup

## Overview
This project includes Docker containerization and CI/CD pipelines for automated testing, building, and deployment.

## Docker Setup

### Files Created
- `Dockerfile` - Multi-stage build configuration for optimized production image
- `.dockerignore` - Excludes unnecessary files from Docker context
- `docker-compose.yml` - Container orchestration configuration

### Building the Docker Image

#### Local Build
```bash
docker build -t ai-quiz-generator .
```

#### Using Docker Compose
```bash
docker-compose build
```

### Running the Container

#### Using Docker directly
```bash
docker run -p 3000:3000 --env-file .env.local ai-quiz-generator
```

#### Using Docker Compose
```bash
docker-compose up
```

Or in detached mode:
```bash
docker-compose up -d
```

### Stopping Containers
```bash
docker-compose down
```

## CI/CD Pipelines

### GitHub Actions Workflows

Two workflows have been created:

#### 1. GitHub Container Registry Pipeline (`.github/workflows/ci-cd.yml`)
- **Triggers**: Push/PR to main or develop branches
- **Features**:
  - Runs tests and linting
  - Builds and pushes to GitHub Container Registry (ghcr.io)
  - Automatic versioning with tags
  - Deployment placeholder (customize for your platform)

#### 2. Docker Hub Pipeline (`.github/workflows/docker-hub.yml`)
- **Triggers**: Push to main, version tags, PRs
- **Features**:
  - Builds and pushes to Docker Hub
  - Multi-tag support (latest, version, sha)
  - Cache optimization

### Setup Requirements

#### For GitHub Container Registry
1. No secrets needed - uses `GITHUB_TOKEN` automatically
2. Enable "Read and write permissions" in:
   - Settings → Actions → General → Workflow permissions

#### For Docker Hub
1. Create Docker Hub account
2. Generate access token at: https://hub.docker.com/settings/security
3. Add GitHub Secrets:
   - `DOCKERHUB_USERNAME` - Your Docker Hub username
   - `DOCKERHUB_TOKEN` - Your Docker Hub access token
4. Go to: Settings → Secrets and variables → Actions → New repository secret

### Environment Variables
Create a `.env.local` file (not committed to git):
```env
OPENAI_API_KEY=your_api_key_here
```

## Docker Image Details

### Multi-stage Build
The Dockerfile uses a multi-stage build for:
- **Smaller image size** (~150MB vs 1GB+)
- **Better security** (production image has no build tools)
- **Faster deployments**

### Stages
1. **deps** - Install dependencies
2. **builder** - Build the Next.js application
3. **runner** - Production runtime (minimal)

## Deployment Options

### Pull and Run from Registry

#### From GitHub Container Registry
```bash
docker pull ghcr.io/YOUR_USERNAME/ai-quiz-generator:latest
docker run -p 3000:3000 --env-file .env.local ghcr.io/YOUR_USERNAME/ai-quiz-generator:latest
```

#### From Docker Hub
```bash
docker pull YOUR_DOCKERHUB_USERNAME/ai-quiz-generator:latest
docker run -p 3000:3000 --env-file .env.local YOUR_DOCKERHUB_USERNAME/ai-quiz-generator:latest
```

### Cloud Platform Deployment

#### AWS ECS / Fargate
- Use the container image URL from registry
- Set environment variables in task definition
- Configure load balancer for port 3000

#### Google Cloud Run
```bash
gcloud run deploy ai-quiz-generator \
  --image ghcr.io/YOUR_USERNAME/ai-quiz-generator:latest \
  --platform managed \
  --port 3000 \
  --allow-unauthenticated
```

#### Azure Container Apps
```bash
az containerapp create \
  --name ai-quiz-generator \
  --resource-group myResourceGroup \
  --image ghcr.io/YOUR_USERNAME/ai-quiz-generator:latest \
  --target-port 3000 \
  --ingress external
```

#### DigitalOcean App Platform
- Connect repository
- App Platform will auto-detect Dockerfile
- Set environment variables in dashboard

## Testing the Docker Build

### Test locally before pushing
```bash
# Build
docker build -t ai-quiz-generator:test .

# Run
docker run -p 3000:3000 -e OPENAI_API_KEY=your_key ai-quiz-generator:test

# Access at http://localhost:3000
```

## Troubleshooting

### Build fails
- Ensure all dependencies are in package.json
- Check Node.js version compatibility (using 18-alpine)

### Container won't start
- Verify environment variables are set
- Check logs: `docker logs <container_id>`

### Permission issues
- Ensure .env.local is readable
- Check file ownership if mounting volumes

## Next Steps

1. **Push to GitHub** - Workflows will trigger automatically
2. **Configure secrets** - Add Docker Hub credentials if using that workflow
3. **Customize deployment** - Update the deploy job in ci-cd.yml for your platform
4. **Monitor builds** - Check Actions tab in GitHub for pipeline status

## Security Notes

- Never commit `.env.local` or API keys
- Use secrets management for production
- Regularly update base images for security patches
- Review and update dependencies regularly
