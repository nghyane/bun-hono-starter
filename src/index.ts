import { createApp } from "@/app";
import { closeDatabaseConnection } from "@config/database";
import { env } from "@config/env";
import { logger } from "@config/logger";

const shutdown = async (signal: string) => {
  logger.info({ signal }, "Shutting down gracefully");

  try {
    await closeDatabaseConnection();
    logger.info("Server shutdown complete");
  } catch (error) {
    logger.error(
      { error: error instanceof Error ? error.message : error },
      "Error during shutdown"
    );
  }

  process.exit(0);
};

process.on("SIGINT", () => shutdown("SIGINT"));
process.on("SIGTERM", () => shutdown("SIGTERM"));

const app = createApp();

const server = Bun.serve({
  port: env.PORT,
  fetch: app.fetch,
  development: env.NODE_ENV === "development",
});

logger.info(
  {
    port: server.port,
    environment: env.NODE_ENV,
    baseUrl: `http://localhost:${server.port}`,
  },
  "Server started successfully"
);
