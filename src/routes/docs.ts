/**
 * Documentation routes
 * Route definitions for OpenAPI documentation, Scalar UI, and API info endpoints
 */

import { env } from "@config/env";
import { scalarDocsHandler } from "@handlers/docs.handler";
import { OpenAPIHono } from "@hono/zod-openapi";

const app = new OpenAPIHono();

// Documentation routes using handlers
if (env.NODE_ENV === "development") {
  app.get("/docs", scalarDocsHandler);
}

export default app;
