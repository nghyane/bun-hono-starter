import type { OpenAPIHono } from "@hono/zod-openapi";
import docsRoutes from "@routes/docs";
import exampleRoutes from "@routes/examples";
import healthRoutes from "@routes/health";

/**
 * Aggregate all API routes
 */
export function setupRoutes(app: OpenAPIHono) {
  // Documentation routes (/, /docs, /info, /openapi.json)
  app.route("/", docsRoutes);

  // Health check routes
  app.route("/", healthRoutes);

  // Example routes (for testing error handling)
  app.route("/", exampleRoutes);

  // Add more route modules here as your API grows
  // Example: app.route('/api/users', userRoutes);
  // Example: app.route('/api/chats', chatRoutes);

  return app;
}
