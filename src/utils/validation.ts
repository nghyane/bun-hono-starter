/**
 * Validation utilities
 * Reusable validation helpers and schemas
 */

import { z } from "zod";

/**
 * Common validation schemas
 */
export const commonSchemas = {
  // ID validation (UUID or numeric)
  id: z.union([
    z.string().uuid("Invalid UUID format"),
    z.string().regex(/^\d+$/, "Invalid numeric ID").transform(Number),
  ]),

  // Pagination parameters
  pagination: z.object({
    page: z.string().regex(/^\d+$/).transform(Number).default("1"),
    limit: z.string().regex(/^\d+$/).transform(Number).default("10"),
    sort: z.string().optional(),
    order: z.enum(["asc", "desc"]).default("asc"),
  }),

  // Email validation
  email: z.string().email("Invalid email format").toLowerCase(),

  // Password validation
  password: z
    .string()
    .min(8, "Password must be at least 8 characters")
    .regex(/[A-Z]/, "Password must contain at least one uppercase letter")
    .regex(/[a-z]/, "Password must contain at least one lowercase letter")
    .regex(/\d/, "Password must contain at least one number"),

  // Phone number validation (basic)
  phone: z.string().regex(/^\+?[\d\s\-\(\)]+$/, "Invalid phone number format"),

  // URL validation
  url: z.string().url("Invalid URL format"),

  // Date validation
  date: z.string().datetime("Invalid date format"),

  // Non-empty string
  nonEmptyString: z.string().min(1, "Field cannot be empty").trim(),
};

/**
 * Validation helper functions
 */
export const validationHelpers = {
  /**
   * Validate pagination parameters
   */
  validatePagination: (params: any) => {
    const result = commonSchemas.pagination.safeParse(params);
    if (!result.success) {
      throw new Error(`Invalid pagination parameters: ${result.error.message}`);
    }
    return result.data;
  },

  /**
   * Validate ID parameter
   */
  validateId: (id: string) => {
    const result = commonSchemas.id.safeParse(id);
    if (!result.success) {
      throw new Error(`Invalid ID format: ${result.error.message}`);
    }
    return result.data;
  },

  /**
   * Create a schema for array validation
   */
  createArraySchema: <T>(
    itemSchema: z.ZodSchema<T>,
    minItems = 0,
    maxItems = 100
  ) => {
    return z
      .array(itemSchema)
      .min(minItems, `Array must contain at least ${minItems} items`)
      .max(maxItems, `Array cannot contain more than ${maxItems} items`);
  },
};

/**
 * Custom validation error class
 */
export class ValidationError extends Error {
  constructor(
    message: string,
    public field?: string,
    public code?: string
  ) {
    super(message);
    this.name = "ValidationError";
  }
}
