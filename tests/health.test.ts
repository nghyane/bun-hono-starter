import { beforeAll, describe, expect, it } from "bun:test";
import { createApp } from "../src/app";

describe("Health Check Endpoints", () => {
  let app: any;

  beforeAll(() => {
    app = createApp();
  });

  describe("GET /health", () => {
    it("should return health status", async () => {
      const req = new Request("http://localhost:3000/health");
      const response = await app.fetch(req);
      const body = await response.json();

      expect(response.status).toBe(200);
      expect(body.status).toMatch(/^(healthy|unhealthy)$/);
      expect(body.version).toBe("2.0.0");
      expect(body.environment).toMatch(/^(development|test|production)$/); // Environment-agnostic
      expect(typeof body.uptime).toBe("number");
      expect(typeof body.timestamp).toBe("string");
    });

    it("should have valid timestamp format", async () => {
      const req = new Request("http://localhost:3000/health");
      const response = await app.fetch(req);
      const body = await response.json();

      const timestamp = new Date(body.timestamp);
      expect(timestamp.getTime()).not.toBeNaN();
    });

    it("should have positive uptime", async () => {
      const req = new Request("http://localhost:3000/health");
      const response = await app.fetch(req);
      const body = await response.json();

      expect(body.uptime).toBeGreaterThan(0);
    });

    it("should reflect database connectivity in status", async () => {
      const req = new Request("http://localhost:3000/health");
      const response = await app.fetch(req);
      const body = await response.json();

      // In CI/CD and development environments, database should be connected
      // so status should be "healthy"
      expect(body.status).toBe("healthy");
      expect(response.status).toBe(200);
    });
  });
});
