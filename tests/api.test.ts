import { beforeAll, describe, expect, it } from "bun:test";
import { createApp } from "../src/app";

describe("API Integration", () => {
  let app: any;

  beforeAll(() => {
    app = createApp();
  });

  describe("Health Endpoint", () => {
    it("should be accessible and return health status", async () => {
      const req = new Request("http://localhost:3000/health");
      const response = await app.fetch(req);
      const body = await response.json();

      expect(response.status).toBe(200);
      expect(body.status).toMatch(/^(healthy|unhealthy)$/);
      expect(body.version).toBe("2.0.0");
      expect(body.environment).toMatch(/^(development|test|production)$/);
      expect(typeof body.uptime).toBe("number");
      expect(typeof body.timestamp).toBe("string");
    });
  });

  describe("Example Routes", () => {
    it("should handle HTTP exceptions", async () => {
      const req = new Request("http://localhost:3000/examples/http-exception");
      const response = await app.fetch(req);
      const body = await response.json();

      expect(response.status).toBe(401);
      expect(body.error.code).toBe("HTTP_EXCEPTION");
      expect(body.error.message).toBe("You are not authorized");
    });

    it("should handle validation errors", async () => {
      const req = new Request(
        "http://localhost:3000/examples/validation-error",
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ name: "", age: -1 }),
        }
      );
      const response = await app.fetch(req);

      expect(response.status).toBe(400);
    });
  });

  describe("404 Handling", () => {
    it("should return 404 for non-existent routes", async () => {
      const req = new Request("http://localhost:3000/non-existent");
      const response = await app.fetch(req);
      const body = await response.json();

      expect(response.status).toBe(404);
      expect(body.error.code).toBe("NOT_FOUND");
      expect(body.error.path).toBe("/non-existent");
    });
  });
});
