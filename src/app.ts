import { OpenAPIHono } from "@hono/zod-openapi";
import { cors } from "hono/cors";
import { prettyJSON } from "hono/pretty-json";
import { requestId } from "hono/request-id";
import { secureHeaders } from "hono/secure-headers";
import { timing } from "hono/timing";

import { env } from "@config/env";
import {
  API_INFO,
  ERROR_CODES,
  HTTP_METHODS,
  HTTP_STATUS,
  OPENAPI_CONFIG,
} from "@constants/app";
import { errorHandler } from "@middleware/errorHandler";
import { pinoLogger } from "@middleware/logger";
import { setupRoutes } from "@routes/index";
import { setupOpenAPIDoc } from "@utils/openapi";

/**
 * Create and configure the Hono application
 * Optimized for Bun runtime
 */
export function createApp() {
  // Create app with Bun-optimized settings
  const app = new OpenAPIHono({
    strict: false, // Better performance in Bun
  });

  // Middleware order optimized for performance
  // 1. Security first
  app.use("*", secureHeaders());

  // 2. CORS (early to handle preflight)
  app.use(
    "*",
    cors({
      origin: env.NODE_ENV === "development" ? "*" : env.CORS_ORIGINS,
      allowMethods: [
        HTTP_METHODS.GET,
        HTTP_METHODS.POST,
        HTTP_METHODS.PUT,
        HTTP_METHODS.DELETE,
        HTTP_METHODS.OPTIONS,
      ],
      allowHeaders: ["Content-Type", "Authorization"],
      credentials: true,
    })
  );

  // 3. Request ID (before logging)
  app.use("*", requestId());

  // 4. Logging (before routes for complete coverage)
  app.use("*", pinoLogger);

  // 5. Performance monitoring
  app.use("*", timing());

  // 6. Development-only middleware
  if (env.NODE_ENV === "development") {
    app.use("*", prettyJSON());
  }

  // Setup OpenAPI documentation
  setupOpenAPIDoc(app);

  // Setup API routes
  setupRoutes(app);

  // 404 handler
  app.notFound((c) => {
    return c.json(
      {
        error: {
          code: ERROR_CODES.NOT_FOUND,
          message: "The requested resource was not found",
          path: c.req.path,
          method: c.req.method,
          timestamp: new Date().toISOString(),
        },
      },
      HTTP_STATUS.NOT_FOUND
    );
  });

  app.onError(errorHandler);

  return app;
}
