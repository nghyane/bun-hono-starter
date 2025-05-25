# Docker Configuration

## Files
- `docker-compose.dev.yml` - Development (PostgreSQL + Redis)
- `docker-compose.prod.yml` - Production (App + DB + Cache)
- `Dockerfile` - Production build
- `README.md` - This file

## Quick Start

Development:
```bash
make services-up    # Start all services
make services-down  # Stop all services
```

Production:
```bash
docker-compose -f docker/docker-compose.prod.yml up -d
```

## Notes
- All services have health checks
- Data persists in Docker volumes
- See root Makefile for more commands
