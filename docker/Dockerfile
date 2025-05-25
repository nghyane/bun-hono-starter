# Use Bun's official image (latest)
FROM oven/bun:alpine AS base

# Install curl and make for health checks and build
RUN apk add --no-cache curl make

# Set working directory
WORKDIR /app

# Copy package files and Makefile
COPY package.json bun.lock Makefile ./

# Install production dependencies
RUN bun install --frozen-lockfile --production

# Copy source code
COPY . .

# Build the application
RUN make build

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

# Start the application
CMD ["bun", "run", "dist/index.js"]
