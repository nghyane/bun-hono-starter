/**
 * Application constants
 */

// API Information
export const API_INFO = {
  NAME: "Hono Bun Starter",
  VERSION: "1.0.0",
  DESCRIPTION: "A modern REST API starter built with Bun, Hono, and PostgreSQL",
  RUNTIME: "Bun",
  FRAMEWORK: "Hono",
} as const;

// HTTP Status Codes
export const HTTP_STATUS = {
  OK: 200,
  BAD_REQUEST: 400,
  NOT_FOUND: 404,
  INTERNAL_SERVER_ERROR: 500,
} as const;

// Error Codes
export const ERROR_CODES = {
  INTERNAL_ERROR: "INTERNAL_ERROR",
  VALIDATION_ERROR: "VALIDATION_ERROR",
  NOT_FOUND: "NOT_FOUND",
  DATABASE_ERROR: "DATABASE_ERROR",
  HTTP_EXCEPTION: "HTTP_EXCEPTION",
  GENERIC_ERROR: "GENERIC_ERROR",
} as const;

// Database Configuration - postgres.js reads from environment variables:
// PGMAXCONNECTIONS, PGIDLE_TIMEOUT, PGCONNECT_TIMEOUT

// OpenAPI Configuration
export const OPENAPI_CONFIG = {
  VERSION: "3.0.0",
  PATHS: {
    DOCS: "/docs",
    OPENAPI_JSON: "/openapi.json",
    HEALTH: "/health",
  },
} as const;

// HTTP Methods
export const HTTP_METHODS = {
  GET: "GET",
  POST: "POST",
  PUT: "PUT",
  DELETE: "DELETE",
  OPTIONS: "OPTIONS",
} as const;

// Content Types
export const CONTENT_TYPES = {
  JSON: "application/json",
  HTML: "text/html",
} as const;

// Health Status
export const HEALTH_STATUS = {
  HEALTHY: "healthy",
  UNHEALTHY: "unhealthy",
} as const;
