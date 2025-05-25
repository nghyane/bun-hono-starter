# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.1] - 2025-01-25

### Improved
- **Enhanced setup command**: Auto-copy `.env.example` to `.env` if not exists
- **Better developer experience**: Zero manual configuration steps
- **Cleaner project structure**: Removed unnecessary reference files

### Removed
- `docs/reference/fpt_university_2025_reference.md`: Unnecessary reference file
- `.env.local` support: Simplified to standard `.env` approach
- Empty directories: Cleaned up project structure

## [2.0.0] - 2025-01-24

### Major Changes
- **PostgreSQL 15 → 17**: Better performance, new features
- **Modular Database**: Organized into 6 logical files
- **UUIDv8 Support**: Time-ordered UUIDs with microsecond precision
- **Standardized Schema**: All tables follow consistent pattern

### Added
- `uuid_generate_v8()`: Optimal UUID generation
- `generate_short_id()`: User-friendly short IDs
- `uuid_extract_timestamp_ms()`: Extract time from UUIDs
- Comprehensive database documentation

### Fixed
- Health check tests for CI/CD compatibility
- Database file execution order
- Package name consistency
- Docker build error with Husky in production

## [1.0.0] - 2025-01-23

### Added
- **Bun Runtime**: Fast JavaScript runtime with built-in bundler
- **Hono Framework**: Lightweight web framework with TypeScript support
- **PostgreSQL Integration**: Database with postgres.js driver
- **OpenAPI Documentation**: Auto-generated docs with Scalar UI
- **TypeScript Support**: Strict type checking and modern syntax
- **Pino Logging**: Structured logging with request tracing
- **Biome Tooling**: Fast linting and formatting
- **Docker Support**: Development and production containers
- **Testing Setup**: Comprehensive test suite with Bun test
- **Pre-commit Hooks**: Automated code quality checks with Husky
- **Health Check Endpoints**: Monitoring and status endpoints
- **Error Handling**: Centralized error management
- **Environment Configuration**: Flexible config management
- **Production Ready**: Optimized build and deployment setup

### Features
- Handler-based architecture following Hono best practices
- Type-safe API with Zod validation
- Request ID tracking and correlation
- Comprehensive error responses
- Auto-generated OpenAPI specifications
- Docker Compose for local development
- CI/CD ready configuration
