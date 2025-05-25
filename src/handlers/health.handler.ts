/**
 * Health check handlers
 * Following Hono best practices - direct export
 */

import { testDatabaseConnection } from "@config/database";
import { env } from "@config/env";
import { API_INFO, HEALTH_STATUS } from "@constants/app";
import { getLogger } from "@middleware/logger";
import type { Context } from "hono";

/**
 * Health check handler
 * Tests database connectivity and returns system status
 */
export const healthHandler = async (c: Context) => {
  const logger = getLogger(c);

  // Test database connection
  logger.debug("Testing database connection");
  const isDatabaseConnected = await testDatabaseConnection();

  const status = isDatabaseConnected
    ? HEALTH_STATUS.HEALTHY
    : HEALTH_STATUS.UNHEALTHY;

  logger.info(
    { status, databaseConnected: isDatabaseConnected },
    "Health check completed"
  );

  return c.json(
    {
      status: status,
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      version: API_INFO.VERSION,
      environment: env.NODE_ENV as string,
    },
    200
  );
};
