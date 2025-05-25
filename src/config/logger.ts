import pino from "pino";
import { env } from "./env";

/**
 * Create Pino logger instance with environment-specific configuration
 */
export const logger = pino({
  level:
    process.env.LOG_LEVEL || (env.NODE_ENV === "production" ? "info" : "debug"),

  // Base configuration
  base: {
    pid: false, // Remove process ID for cleaner logs
    hostname: false, // Remove hostname for cleaner logs
  },

  // Timestamp configuration
  timestamp: pino.stdTimeFunctions.isoTime,

  // Development configuration
  ...(env.NODE_ENV === "development" && {
    transport: {
      target: "pino-pretty",
      options: {
        colorize: true,
        translateTime: "HH:MM:ss",
        ignore: "pid,hostname",
        singleLine: true,
      },
    },
  }),

  // Production configuration
  ...(env.NODE_ENV === "production" && {
    formatters: {
      level: (label) => ({ level: label }),
    },
  }),
});

/**
 * Create child logger with additional context
 */
export function createChildLogger(context: Record<string, unknown>) {
  return logger.child(context);
}

/**
 * Log levels for reference:
 * - fatal (60): The service/app is going to stop or become unusable
 * - error (50): Fatal for a particular request, but the service continues
 * - warn (40): A note on something that should probably be looked at
 * - info (30): General operational entries about what's happening
 * - debug (20): Less important stuff for debugging
 * - trace (10): Very detailed application logging
 */
