# 🚀 Starter Template Guide

This guide helps you customize this starter template for your specific project.

## 📋 Checklist for New Projects

### 1. Project Information
- [ ] Update `package.json` name, description, author
- [ ] Update `src/constants/app.ts` API_INFO
- [ ] Update `README.md` title and description
- [ ] Update `docker/README.md` if needed

### 2. Environment Setup
- [ ] Copy `.envrc` to `.env.local` for personal overrides
- [ ] Update database name in `.envrc` 
- [ ] Configure production environment variables

### 3. Database Setup
- [ ] Update database name in `docker/docker-compose.dev.yml`
- [ ] Create your database schema in `docs/database/`
- [ ] Add migration scripts if needed

### 4. API Development
- [ ] Remove example routes in `src/routes/examples.ts`
- [ ] Create your domain-specific routes
- [ ] Add corresponding handlers
- [ ] Define Zod schemas for validation

### 5. Customization
- [ ] Update OpenAPI info in `src/utils/openapi.ts`
- [ ] Add your custom middleware if needed
- [ ] Configure CORS origins for production
- [ ] Add authentication if required

## 🎯 Common Patterns

### Adding a New Feature

1. **Create Schema** (`src/schemas/user.ts`)
```typescript
import { z } from "zod";

export const createUserSchema = z.object({
  name: z.string().min(1),
  email: z.string().email(),
});

export type CreateUser = z.infer<typeof createUserSchema>;
```

2. **Create Handler** (`src/handlers/user.handler.ts`)
```typescript
import type { Context } from "hono";
import { createUserSchema } from "@schemas/user";

export const createUserHandler = async (c: Context) => {
  const data = c.req.valid("json");
  // Your business logic here
  return c.json({ user: data }, 201);
};
```

3. **Create Route** (`src/routes/users.ts`)
```typescript
import { OpenAPIHono, createRoute } from "@hono/zod-openapi";
import { zValidator } from "@hono/zod-validator";
import { createUserHandler } from "@handlers/user.handler";
import { createUserSchema } from "@schemas/user";

const app = new OpenAPIHono();

const createUserRoute = createRoute({
  method: "post",
  path: "/users",
  request: {
    body: {
      content: {
        "application/json": {
          schema: createUserSchema,
        },
      },
    },
  },
  responses: {
    201: {
      description: "User created successfully",
    },
  },
});

app.openapi(createUserRoute, createUserHandler);

export default app;
```

4. **Register Route** (`src/routes/index.ts`)
```typescript
import userRoutes from "@routes/users";

export function setupRoutes(app: OpenAPIHono) {
  // ... existing routes
  app.route("/api", userRoutes);
}
```

## 🔧 Development Tips

1. **Use path aliases** for clean imports
2. **Follow Hono patterns** - handlers over controllers
3. **Validate everything** with Zod schemas
4. **Type everything** with TypeScript
5. **Test your endpoints** with the built-in test setup

## 📚 Resources

- [Hono Documentation](https://hono.dev/)
- [Bun Documentation](https://bun.sh/docs)
- [Zod Documentation](https://zod.dev/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
