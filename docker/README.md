# Docker Configuration

Clean, organized Docker setup for development and production environments with Traefik reverse proxy.

## 📁 Directory Structure

```
docker/
├── Dockerfile              # Production-optimized image
├── dev/
│   └── docker-compose.yml  # Development services
├── prod/
│   ├── docker-compose.yml  # Production with Traefik
│   ├── .env.example        # Environment template
│   └── deploy.sh           # Deployment script
└── traefik/
    └── traefik.yml         # Traefik configuration
```

## 🚀 Development

```bash
# Start development services
make db-up

# Or manually
docker-compose -f docker/dev/docker-compose.yml up -d
```

## 🌐 Production Deployment with Traefik

### Features:
- **Automatic HTTPS** with Let's Encrypt
- **Rate limiting** and security headers
- **Load balancing** ready
- **Dashboard** monitoring
- **Zero-downtime** deployments

### Quick Start:

```bash
# 1. Setup environment
cd docker/prod/
cp .env.example .env
# Edit .env with your domain and credentials

# 2. Deploy
./deploy.sh

# 3. Deploy specific version
./deploy.sh v2.0.0
```

### Manual Deployment:

```bash
# 1. Create Traefik network
docker network create traefik

# 2. Pull latest image
docker pull ghcr.io/nghyane/bun-hono-starter:latest

# 3. Start stack
cd docker/prod/
docker-compose --env-file .env up -d
```

## 🔧 Environment Variables

### Production (.env)

```bash
# Domain (required for HTTPS)
DOMAIN=yourdomain.com

# Database
POSTGRES_DB=starter_prod
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_secure_password

# Optional: Custom image tag
IMAGE_TAG=v2.0.0
```

## 🌍 Access Points

### Production:
- **API**: `https://api.yourdomain.com`
- **Health**: `https://api.yourdomain.com/health`
- **Docs**: `https://api.yourdomain.com/docs`
- **Traefik Dashboard**: `http://localhost:8080`

### Development:
- **API**: `http://localhost:3000`
- **PostgreSQL**: `localhost:5432`
- **Redis**: `localhost:6379`

## 📊 Monitoring

### Health Checks:
- **App**: HTTP health endpoint
- **PostgreSQL**: `pg_isready`
- **Traefik**: Built-in health checks

### Logs:
```bash
# Application logs
docker-compose logs app

# Traefik logs
docker-compose logs traefik

# All services
docker-compose logs
```

## 🔒 Security Features

- **Automatic HTTPS** with Let's Encrypt
- **Rate limiting**: 10 req/s average, 100 burst
- **Security headers**: HSTS, X-Frame-Options, etc.
- **Network isolation**: Separate frontend/backend networks
- **Non-root containers**: Security best practices

## 🎯 Benefits of This Setup

### vs Nginx:
- **Auto SSL**: No manual certificate management
- **Service Discovery**: Automatic container detection
- **Load Balancing**: Built-in with health checks
- **Hot Reload**: Zero-downtime deployments
- **Dashboard**: Real-time monitoring

### vs Direct Docker:
- **Production Ready**: HTTPS, monitoring, security
- **Scalable**: Easy to add more services
- **Maintainable**: Clean separation of concerns
- **Professional**: Industry-standard setup
