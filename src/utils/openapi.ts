/**
 * OpenAPI utilities
 * Helper functions for OpenAPI documentation setup
 */

import { env } from "@config/env";
import { API_INFO, OPENAPI_CONFIG } from "@constants/app";
import type { OpenAPIHono } from "@hono/zod-openapi";

/**
 * Get dynamic server configuration based on environment
 */
function getServerConfig() {
  const baseUrl =
    env.NODE_ENV === "production"
      ? "https://your-domain.com" // Replace with actual production URL
      : `http://localhost:${env.PORT}`;

  return [
    {
      url: baseUrl,
      description:
        env.NODE_ENV === "production"
          ? "Production server"
          : "Development server",
    },
  ];
}

/**
 * Setup OpenAPI documentation
 * Configures OpenAPI spec generation for development
 */
export function setupOpenAPIDoc(app: OpenAPIHono) {
  // OpenAPI JSON endpoint - only in development
  if (env.NODE_ENV === "development") {
    app.doc(OPENAPI_CONFIG.PATHS.OPENAPI_JSON, {
      openapi: OPENAPI_CONFIG.VERSION,
      info: {
        version: API_INFO.VERSION,
        title: API_INFO.NAME,
        description: API_INFO.DESCRIPTION,
        contact: {
          name: "API Support",
          email: "support@example.com", // Replace with actual contact
        },
        license: {
          name: "MIT",
          url: "https://opensource.org/licenses/MIT",
        },
      },
      servers: getServerConfig(),
      tags: [
        {
          name: "Health",
          description: "Health check and system status endpoints",
        },
        {
          name: "Examples",
          description:
            "Example endpoints demonstrating error handling and validation",
        },
        {
          name: "Authentication",
          description: "Authentication and authorization endpoints",
        },
      ],
    });
  }
}
