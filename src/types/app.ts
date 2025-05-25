/**
 * Global application types for Hono
 * Defines the structure for Variables, Bindings, and Environment
 */

import type { Logger } from "pino";

/**
 * Variables available in Hono context
 * These are set by middleware and available in handlers
 */
export type AppVariables = {
  logger: Logger;
  requestId: string;
};

/**
 * Bindings for runtime-specific features
 * (e.g., Cloudflare Workers bindings, environment variables)
 */
export type AppBindings = Record<string, never>;

/**
 * Complete environment type for the Hono app
 */
export type AppEnv = {
  Variables: AppVariables;
  Bindings: AppBindings;
};

/**
 * Type-safe context type
 */
export type AppContext = {
  Variables: AppVariables;
  Bindings: AppBindings;
};
