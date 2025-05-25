# Optimized Makefile for Personal API Starter
.SILENT:

# Variables
PROJECT_NAME := personal-api-starter
DOCKER_COMPOSE_DEV := docker/dev/docker-compose.yml
BUILD_DIR := dist

.PHONY: help install dev test build clean services-up services-down db-reset setup start fix

help: ## Show available commands
	echo 'Usage: make [target]'
	echo ''
	echo 'Available targets:'
	awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# Dependencies
node_modules: package.json bun.lock
	echo "📦 Installing dependencies..."
	bun install
	touch node_modules

install: node_modules ## Install dependencies

# Development
dev: node_modules ## Start development server
	echo "🚀 Starting development server..."
	bun run --watch src/index.ts

# Code Quality
fix: node_modules ## Check and auto-fix code issues
	echo "🔧 Checking and fixing code issues..."
	bunx biome check --write .
	echo "🔍 Running TypeScript check..."
	bunx tsc --noEmit

# Testing
test: node_modules ## Run tests
	echo "🧪 Running tests..."
	bun test

# Build
$(BUILD_DIR): src/index.ts src/**/*.ts
	echo "🏗️  Building for production..."
	bun build src/index.ts --outdir ./$(BUILD_DIR) --target bun
	touch $(BUILD_DIR)

build: $(BUILD_DIR) ## Build for production

clean: ## Clean build artifacts
	echo "🧹 Cleaning build artifacts..."
	rm -rf $(BUILD_DIR) node_modules/.cache

# Docker services
services-up: ## Start development services
	echo "🐳 Starting development services..."
	docker-compose -f $(DOCKER_COMPOSE_DEV) up -d
	echo "⏳ Waiting for services to be ready..."
	sleep 5

services-down: ## Stop development services
	echo "🛑 Stopping development services..."
	docker-compose -f $(DOCKER_COMPOSE_DEV) down

db-reset: ## Reset database
	echo "🗄️  Resetting database..."
	docker-compose -f $(DOCKER_COMPOSE_DEV) down -v
	docker-compose -f $(DOCKER_COMPOSE_DEV) up -d postgres
	echo "⏳ Waiting for database to be ready..."
	sleep 10

# Project setup
setup: install ## Initial project setup
	echo "📋 Setting up environment files..."
	if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "📄 Created .env from .env.example"; \
	else \
		echo "📄 .env already exists"; \
	fi
	$(MAKE) services-up
	echo "✅ Project setup complete!"
	echo "🚀 Run 'make dev' to start development"

# Production
start: build ## Start production server locally
	echo "🚀 Starting production server..."
	bun run $(BUILD_DIR)/index.js
