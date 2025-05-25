# Changelog

## [2.0.0] - 2025-05-25

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

## [1.0.0] - 2025-01-24

Initial release with Bun + Hono + PostgreSQL stack
