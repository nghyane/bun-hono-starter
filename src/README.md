# Source Code Structure

This directory contains the main application source code organized following Hono best practices.

## Directory Structure

```
src/
├── config/          # Configuration files (database, env, logger)
├── constants/       # Application constants and enums
├── handlers/        # Route handlers (Hono best practice)
├── middleware/      # Custom middleware functions
├── routes/          # Route definitions and OpenAPI specs
├── schemas/         # Zod validation schemas
├── types/           # TypeScript type definitions
├── utils/           # Utility functions and helpers
├── app.ts           # Main Hono application setup
└── index.ts         # Application entry point
```

## Key Principles

1. **Handlers over Controllers**: Following Hono best practices, we use handlers instead of traditional MVC controllers
2. **Path Aliases**: Use TypeScript path mapping for clean imports (e.g., `@config/*`, `@handlers/*`)
3. **Type Safety**: Comprehensive TypeScript types and Zod schemas
4. **Separation of Concerns**: Clear separation between routes, handlers, middleware, and configuration

## Adding New Features

1. **Routes**: Add new route files in `routes/` directory
2. **Handlers**: Create corresponding handlers in `handlers/` directory  
3. **Schemas**: Define Zod schemas in `schemas/` directory
4. **Types**: Add TypeScript types in `types/` directory

## Import Conventions

```typescript
// Use path aliases for internal imports
import { env } from "@config/env";
import { healthHandler } from "@handlers/health.handler";
import { healthResponseSchema } from "@schemas/health";

// Use relative imports only for same-directory files
import { helper } from "./helper";
```
