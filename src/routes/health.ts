import { healthHandler } from "@handlers/health.handler";
import { OpenAPIHono, createRoute } from "@hono/zod-openapi";
import { healthResponseSchema } from "@schemas/health";

const app = new OpenAPIHono();

// Health check route
const healthRoute = createRoute({
  method: "get",
  path: "/health",
  tags: ["Health"],
  summary: "Health check",
  description:
    "Returns health status of the API including database connectivity",
  security: [], // Public endpoint - no authentication required
  responses: {
    200: {
      content: {
        "application/json": {
          schema: healthResponseSchema,
        },
      },
      description: "Health status - service is healthy",
    },
    503: {
      content: {
        "application/json": {
          schema: healthResponseSchema,
        },
      },
      description: "Service unavailable - database connection failed",
    },
  },
});

// Health check handler - using separated handler following Hono best practices
app.openapi(healthRoute, healthHandler);

export default app;
