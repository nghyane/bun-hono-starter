#!/bin/bash

# Production Deployment Script with Traefik
set -e

echo "🚀 Starting production deployment with Traefik..."

# Configuration
COMPOSE_FILE="docker-compose.yml"
ENV_FILE=".env"
IMAGE_TAG=${1:-latest}

# Check if we're in the right directory
if [ ! -f "$COMPOSE_FILE" ]; then
    echo "❌ Please run this script from the docker/prod/ directory"
    exit 1
fi

# Check if environment file exists
if [ ! -f "$ENV_FILE" ]; then
    echo "❌ Environment file not found: $ENV_FILE"
    echo "Please copy .env.example to .env and configure it"
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
docker-compose --env-file $ENV_FILE down

# Start production stack
echo "🚀 Starting production stack with Traefik..."
docker-compose --env-file $ENV_FILE up -d

# Wait for services to be healthy
echo "⏳ Waiting for services to be healthy..."
sleep 45

# Check health
echo "🔍 Checking service health..."
DOMAIN=$(grep DOMAIN $ENV_FILE | cut -d'=' -f2)
if [ "$DOMAIN" = "yourdomain.com" ] || [ -z "$DOMAIN" ]; then
    HEALTH_URL="http://localhost:3000/health"
else
    HEALTH_URL="https://api.$DOMAIN/health"
fi

if curl -f $HEALTH_URL > /dev/null 2>&1; then
    echo "✅ Application is healthy!"
    echo "🌐 API: https://api.$DOMAIN (or http://localhost:3000)"
    echo "📊 Health: $HEALTH_URL"
    echo "📚 API docs: https://api.$DOMAIN/docs"
    echo "🎛️  Traefik dashboard: http://localhost:8080"
else
    echo "❌ Application health check failed"
    echo "📋 Checking logs..."
    docker-compose --env-file $ENV_FILE logs app
    exit 1
fi

# Show running containers
echo ""
echo "📊 Running containers:"
docker-compose --env-file $ENV_FILE ps

echo ""
echo "🎉 Production deployment with Traefik completed successfully!"
