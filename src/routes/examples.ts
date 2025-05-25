/**
 * Example routes to demonstrate error handling
 * These routes show different types of errors and how they're handled
 */

import { AppError } from "@app-types/errors";
import { HTTP_STATUS } from "@constants/app";
import { OpenAPIHono, createRoute } from "@hono/zod-openapi";
import { zValidator } from "@hono/zod-validator";
import { HTTPException } from "hono/http-exception";
import { z } from "zod";

const app = new OpenAPIHono();

// Example route that throws HTTPException
const httpExceptionRoute = createRoute({
  method: "get",
  path: "/examples/http-exception",
  tags: ["Examples"],
  summary: "Throws HTTPException",
  description: "Demonstrates HTTPException handling",
  responses: {
    401: {
      description: "Unauthorized",
      content: {
        "application/json": {
          schema: z.object({
            error: z.object({
              message: z.string(),
              code: z.string(),
              requestId: z.string(),
              timestamp: z.string(),
            }),
          }),
        },
      },
    },
  },
});

app.openapi(httpExceptionRoute, (c) => {
  throw new HTTPException(401, { message: "You are not authorized" });
});

// Simple validation error route (without OpenAPI for simplicity)
app.post(
  "/examples/validation-error",
  zValidator(
    "json",
    z.object({
      name: z.string().min(1, "Name is required"),
      age: z.number().min(0, "Age must be positive"),
    })
  ),
  (c) => {
    const data = c.req.valid("json");
    return c.json({ message: "Success", data }, 200);
  }
);

// Example route that throws custom AppError
const appErrorRoute = createRoute({
  method: "get",
  path: "/examples/app-error",
  tags: ["Examples"],
  summary: "Throws custom AppError",
  description: "Demonstrates custom AppError handling",
  responses: {
    404: {
      description: "Not found",
      content: {
        "application/json": {
          schema: z.object({
            error: z.object({
              message: z.string(),
              code: z.string(),
              requestId: z.string(),
              timestamp: z.string(),
            }),
          }),
        },
      },
    },
  },
});

app.openapi(appErrorRoute, (_c) => {
  throw new AppError(
    "Resource not found",
    HTTP_STATUS.NOT_FOUND,
    true,
    "RESOURCE_NOT_FOUND"
  );
});

// Example route that throws unknown error
const unknownErrorRoute = createRoute({
  method: "get",
  path: "/examples/unknown-error",
  tags: ["Examples"],
  summary: "Throws unknown error",
  description: "Demonstrates unknown error handling",
  responses: {
    500: {
      description: "Internal server error",
      content: {
        "application/json": {
          schema: z.object({
            error: z.object({
              message: z.string(),
              code: z.string(),
              requestId: z.string(),
              timestamp: z.string(),
              stack: z.string().optional(),
            }),
          }),
        },
      },
    },
  },
});

app.openapi(unknownErrorRoute, (_c) => {
  throw new Error("Something went wrong unexpectedly");
});

export default app;
