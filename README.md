# 🚀 Hono Bun Starter

A modern, production-ready REST API starter template built with **Bun**, **Hono**, **PostgreSQL**, and **TypeScript**.

## ✨ Features

- 🏃‍♂️ **Bun Runtime** - Ultra-fast JavaScript runtime
- 🔥 **Hono Framework** - Lightweight, fast web framework
- 🗄️ **PostgreSQL** - Robust database with postgres.js
- 📝 **TypeScript** - Full type safety
- 📚 **OpenAPI/Swagger** - Auto-generated API documentation
- 🧪 **Testing** - Bun test runner setup
- 🔍 **Logging** - Pino logger with request tracing
- 🛡️ **Security** - Built-in security headers
- 🔧 **Development** - Hot reload, linting, formatting
- 🐳 **Docker** - Ready for containerization

## 🚀 Quick Start

### 1. Clone and Setup

```bash
# Clone the repository
git clone <your-repo-url>
cd hono-bun-starter

# Install Bun (if not already installed)
curl -fsSL https://bun.sh/install | bash

# One-time setup
make setup
```

### 2. Environment Setup (Recommended)

```bash
# Install direnv for automatic environment loading
brew install direnv  # macOS
# or: sudo apt install direnv  # Ubuntu

# Add to your shell profile
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc  # or ~/.zshrc
source ~/.bashrc  # or restart terminal

# Allow direnv for this project
direnv allow
```

### 3. Start Development

```bash
# Start development server with hot reload
make dev

# Or manually
bun run --watch src/index.ts
```

### 4. Customize for Your Project

1. **Update project info** in `package.json`
2. **Change API name** in `src/constants/app.ts`
3. **Add your routes** in `src/routes/`
4. **Create handlers** in `src/handlers/`
5. **Define schemas** in `src/schemas/`

## Commands

```bash
make dev             # Start development server
make test            # Run tests
make build           # Build for production
make start           # Start production server locally
make services-up     # Start development services (PostgreSQL + Redis)
make services-down   # Stop development services
make docker-info     # Show Docker build information
make help            # Show all commands
```

## Environment Management

Uses `direnv` for automatic environment loading with sensible defaults:

- **`.envrc`** - Default development settings
- **`.env.local`** - Personal overrides (optional)

Override for different environments:
```bash
NODE_ENV=production make start   # Production mode
```

## API Docs

- **Documentation**: http://localhost:3000/docs
- **Health Check**: http://localhost:3000/health

## 🏗️ Architecture

```
src/
├── config/          # Configuration (database, env, logger)
├── constants/       # Application constants
├── handlers/        # Route handlers (Hono best practice)
├── middleware/      # Custom middleware
├── routes/          # Route definitions + OpenAPI specs
├── schemas/         # Zod validation schemas
├── types/           # TypeScript type definitions
├── utils/           # Utility functions
├── app.ts           # Main Hono application setup
└── index.ts         # Application entry point
```

## 🛠️ Tech Stack

- **Runtime**: [Bun](https://bun.sh/) - Ultra-fast JavaScript runtime
- **Framework**: [Hono](https://hono.dev/) - Lightweight web framework
- **Database**: [PostgreSQL](https://www.postgresql.org/) + [postgres.js](https://github.com/porsager/postgres)
- **Validation**: [Zod](https://zod.dev/) - TypeScript-first schema validation
- **Logging**: [Pino](https://getpino.io/) - Fast JSON logger
- **Testing**: Bun test runner
- **Docs**: OpenAPI 3.0 + [Scalar](https://scalar.com/)
- **Code Quality**: [Biome](https://biomejs.dev/) - Fast linter & formatter
- **Git Hooks**: [Husky](https://typicode.github.io/husky/) + lint-staged
