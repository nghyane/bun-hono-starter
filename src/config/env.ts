import { z } from "zod";

/**
 * Environment variables schema validation
 */
const envSchema = z.object({
  DATABASE_URL: z.string().url("Invalid database URL"),
  PORT: z.string().transform(Number).default("3000"),
  NODE_ENV: z
    .enum(["development", "production", "test"])
    .default("development"),
  CORS_ORIGINS: z
    .string()
    .optional()
    .transform((val) => (val ? val.split(",").map((s) => s.trim()) : [])),
});

/**
 * Parse and validate environment variables
 */
const result = envSchema.safeParse(process.env);

if (!result.success) {
  // Use console.error here since logger isn't available yet
  console.error("❌ Invalid environment variables:", result.error.format());
  process.exit(1);
}

export const env = result.data;

export type Env = z.infer<typeof envSchema>;
