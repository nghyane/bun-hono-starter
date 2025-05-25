#!/bin/bash

# Production Deployment Script with Traefik
set -e

echo "🚀 Starting production deployment with Traefik..."

# Configuration
COMPOSE_FILE="docker-compose.yml"
IMAGE_TAG=${1:-latest}

# Check if we're in the right directory
if [ ! -f "$COMPOSE_FILE" ]; then
    echo "❌ Please run this script from the docker/prod/ directory"
    exit 1
fi

# Create Traefik network if it doesn't exist
echo "🌐 Creating Traefik network..."
docker network create traefik 2>/dev/null || echo "Network 'traefik' already exists"

# Pull latest image from CI/CD
echo "📦 Pulling image: ghcr.io/nghyane/bun-hono-starter:$IMAGE_TAG"
docker pull ghcr.io/nghyane/bun-hono-starter:$IMAGE_TAG

# Update image tag in compose file if not latest
if [ "$IMAGE_TAG" != "latest" ]; then
    echo "🔄 Using image tag: $IMAGE_TAG"
    export IMAGE_TAG
fi

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker-compose down

# Start production stack
echo "🚀 Starting production stack with Traefik..."
docker-compose up -d

# Wait for services to be healthy
echo "⏳ Waiting for services to be healthy..."
sleep 45

# Check health
echo "🔍 Checking service health..."
HEALTH_URL="http://localhost:3000/health"

if curl -f $HEALTH_URL > /dev/null 2>&1; then
    echo "✅ Application is healthy!"
    echo "🌐 API: http://localhost:3000"
    echo "📊 Health: $HEALTH_URL"
    echo "📚 API docs: http://localhost:3000/docs"
    echo "🎛️  Traefik dashboard: http://localhost:8080"
else
    echo "❌ Application health check failed"
    echo "📋 Checking logs..."
    docker-compose logs app
    exit 1
fi

# Show running containers
echo ""
echo "📊 Running containers:"
docker-compose ps

echo ""
echo "🎉 Production deployment with Traefik completed successfully!"
