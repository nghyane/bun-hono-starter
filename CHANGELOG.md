# Changelog

## [2.0.1] - 2025-01-25

### Improved
- **Enhanced setup command**: Auto-copy `.env.example` to `.env` if not exists
- **Better developer experience**: Zero manual configuration steps
- **Cleaner project structure**: Removed unnecessary reference files

### Removed
- `docs/reference/fpt_university_2025_reference.md`: Unnecessary reference file
- `.env.local` support: Simplified to standard `.env` approach
- Empty directories: Cleaned up project structure

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
