import { DatabaseError } from "@app-types/errors";
import { logger } from "@config/logger";
import postgres from "postgres";
import { env } from "./env";

/**
 * PostgreSQL database connection
 * Uses postgres.js defaults from environment variables:
 * - PGMAXCONNECTIONS (default: 10)
 * - PGIDLE_TIMEOUT (default: 0)
 * - PGCONNECT_TIMEOUT (default: 30)
 */
export const sql = postgres(env.DATABASE_URL, {
  // Transform settings
  transform: {
    undefined: null,
  },

  // Development settings
  debug: env.NODE_ENV === "development",
});

/**
 * Internal function to test database connectivity
 */
async function _testConnection(): Promise<void> {
  await sql`SELECT 1 as test`;
  logger.debug("Database connection test successful");
}

/**
 * Test database connectivity - returns boolean
 */
export async function testDatabaseConnection(): Promise<boolean> {
  try {
    await _testConnection();
    return true;
  } catch (error) {
    logger.error(
      { error: error instanceof Error ? error.message : error },
      "Database connection failed"
    );
    return false;
  }
}

/**
 * Test database connectivity - throws on failure
 */
export async function ensureDatabaseConnection(): Promise<void> {
  try {
    await _testConnection();
  } catch (error) {
    const errorMessage =
      error instanceof Error ? error.message : "Unknown database error";
    logger.error({ error: errorMessage }, "Database connection failed");
    throw new DatabaseError(`Database connection failed: ${errorMessage}`);
  }
}

/**
 * Close database connection gracefully
 */
export async function closeDatabaseConnection(): Promise<void> {
  await sql.end();
}
