# 🚀 Personal API Starter

My personal REST API starter built with **Bun**, **Hono**, **PostgreSQL**, and **TypeScript**.

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

```bash
# One-time setup
make setup

# Install and setup direnv (recommended)
brew install direnv
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc  # or ~/.zshrc
direnv allow

# Start development
make dev
```

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



## 🛠️ Tech Stack

- **Runtime**: [Bun](https://bun.sh/) - Ultra-fast JavaScript runtime
- **Framework**: [Hono](https://hono.dev/) - Lightweight web framework
- **Database**: [PostgreSQL 17](https://www.postgresql.org/) + [postgres.js](https://github.com/porsager/postgres)
- **Validation**: [Zod](https://zod.dev/) - TypeScript-first schema validation
- **Logging**: [Pino](https://getpino.io/) - Fast JSON logger
- **Testing**: Bun test runner
- **Docs**: OpenAPI 3.0 + [Scalar](https://scalar.com/)
- **Code Quality**: [Biome](https://biomejs.dev/) - Fast linter & formatter
- **Git Hooks**: [Husky](https://typicode.github.io/husky/) + lint-staged
