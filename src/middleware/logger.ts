import { createChildLogger, logger } from "@config/logger";
import type { Context } from "hono";
import { createMiddleware } from "hono/factory";
import type { Logger } from "pino";

/**
 * Type definitions for logger middleware
 */
type LoggerVariables = {
  logger: Logger;
  requestId: string;
};

/**
 * Pino logging middleware for Hono
 * Uses Hono's createMiddleware for better type safety
 */
export const pinoLogger = createMiddleware<{ Variables: LoggerVariables }>(
  async (c, next) => {
    const start = Date.now();
    // Use built-in request ID from Hono's requestId middleware
    const requestId = c.get("requestId") || "unknown";

    // Create child logger with request context
    const requestLogger = createChildLogger({
      requestId,
      method: c.req.method,
      url: c.req.url,
      userAgent: c.req.header("user-agent"),
    });

    // Add logger to context for use in route handlers
    c.set("logger", requestLogger);
    c.set("requestId", requestId);

    // Log incoming request
    requestLogger.info("Request started");

    try {
      await next();
    } catch (error) {
      // Log error
      requestLogger.error(
        { error: error instanceof Error ? error.message : error },
        "Request failed"
      );
      throw error;
    } finally {
      const duration = Date.now() - start;
      const status = c.res.status;

      // Log completed request
      requestLogger.info(
        {
          status,
          duration,
          responseSize: c.res.headers.get("content-length"),
        },
        "Request completed"
      );
    }
  }
);

/**
 * Get logger from Hono context
 */
export function getLogger(c: Context) {
  return c.get("logger") || logger;
}

/**
 * Get request ID from Hono context
 */
export function getRequestId(c: Context): string {
  return c.get("requestId") || "unknown";
}
