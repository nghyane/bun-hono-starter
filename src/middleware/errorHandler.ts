import { AppError } from "@app-types/errors";
import { env } from "@config/env";
import { ERROR_CODES, HTTP_STATUS } from "@constants/app";
import { getLogger, getRequestId } from "@middleware/logger";
import type { Context } from "hono";
import { HTTPException } from "hono/http-exception";
import { ZodError } from "zod";

/**
 * Global error handler middleware
 * Simplified and optimized following Hono best practices
 */
export const errorHandler = async (err: Error, c: Context) => {
  const logger = getLogger(c);
  const requestId = getRequestId(c);

  // Handle HTTPException first (Hono best practice)
  if (err instanceof HTTPException) {
    // Use HTTPException's built-in response if available
    if (err.res) {
      logger.warn(
        {
          status: err.status,
          message: err.message,
          requestId,
        },
        "HTTP exception with custom response"
      );
      return err.getResponse();
    }

    // Standard HTTPException handling
    logger.warn(
      {
        status: err.status,
        message: err.message,
        requestId,
      },
      "HTTP exception"
    );

    return c.json(
      {
        error: {
          message: err.message,
          code: ERROR_CODES.HTTP_EXCEPTION,
          requestId,
          timestamp: new Date().toISOString(),
        },
      },
      err.status
    );
  }

  // Handle Zod validation errors
  if (err instanceof ZodError) {
    const details = err.errors.map((e) => ({
      field: e.path.join("."),
      message: e.message,
      code: e.code,
    }));

    logger.warn(
      {
        validationErrors: details,
        requestId,
      },
      "Validation error"
    );

    return c.json(
      {
        error: {
          message: "Validation failed",
          code: ERROR_CODES.VALIDATION_ERROR,
          requestId,
          timestamp: new Date().toISOString(),
          details,
        },
      },
      HTTP_STATUS.BAD_REQUEST
    );
  }

  // Handle custom AppError
  if (err instanceof AppError) {
    const isServerError = err.statusCode >= 500;

    logger[isServerError ? "error" : "warn"](
      {
        error: err.message,
        statusCode: err.statusCode,
        code: err.code,
        requestId,
        ...(isServerError &&
          env.NODE_ENV === "development" && { stack: err.stack }),
      },
      isServerError ? "Server error" : "Client error"
    );

    return c.json(
      {
        error: {
          message: err.message,
          code: err.code || ERROR_CODES.INTERNAL_ERROR,
          requestId,
          timestamp: new Date().toISOString(),
          ...(env.NODE_ENV === "development" &&
            err.stack && { stack: err.stack }),
        },
      },
      err.statusCode as never
    );
  }

  // Handle unknown errors
  logger.error(
    {
      error: err.message,
      requestId,
      ...(env.NODE_ENV === "development" && { stack: err.stack }),
    },
    "Unknown error"
  );

  return c.json(
    {
      error: {
        message: "Internal Server Error",
        code: ERROR_CODES.INTERNAL_ERROR,
        requestId,
        timestamp: new Date().toISOString(),
        ...(env.NODE_ENV === "development" &&
          err.stack && { stack: err.stack }),
      },
    },
    HTTP_STATUS.INTERNAL_SERVER_ERROR
  );
};

/**
 * Helper to throw errors easily
 */
export function throwError(
  message: string,
  statusCode = HTTP_STATUS.INTERNAL_SERVER_ERROR,
  code?: string
): never {
  throw new AppError(message, statusCode, true, code);
}
