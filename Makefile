# Adeliom Docker Images - Main Makefile
# Orchestrates PHP and Redis image builds

.PHONY: help

# Colors for output
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m # No Color

help: ## Show this help message
	@echo "$(BLUE)╔════════════════════════════════════════════╗$(NC)"
	@echo "$(BLUE)║   Adeliom Docker Images                    ║$(NC)"
	@echo "$(BLUE)╚════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(YELLOW)Quick Commands:$(NC)"
	@echo "  $(GREEN)make php-help$(NC)       - Show all PHP commands"
	@echo "  $(GREEN)make redis-help$(NC)     - Show all Redis commands"
	@echo "  $(GREEN)cd php && make help$(NC) - PHP detailed help"
	@echo "  $(GREEN)cd redis && make help$(NC) - Redis detailed help"
	@echo ""
	@echo "$(YELLOW)PHP Quick Start:$(NC)"
	@echo "  $(GREEN)make php-cli@8.4$(NC)         - Build PHP 8.4 CLI"
	@echo "  $(GREEN)make php-caddy@8.3$(NC)       - Build PHP 8.3 Caddy"
	@echo "  $(GREEN)make php-apache@8.2-debug$(NC) - Debug PHP 8.2 Apache"
	@echo ""
	@echo "$(YELLOW)Redis Quick Start:$(NC)"
	@echo "  $(GREEN)make redis@7.4$(NC)       - Build & test Redis 7.4"
	@echo "  $(GREEN)make redis-build$(NC)     - Build Redis latest"
	@echo "  $(GREEN)make redis-test$(NC)      - Test Redis"
	@echo ""
	@echo "$(BLUE)For detailed documentation, see:$(NC)"
	@echo "  - README.md"
	@echo "  - MAKEFILE_USAGE.md"

.DEFAULT_GOAL := help

# ========== PHP COMMANDS ==========

php-help: ## Show PHP commands
	@cd php && make help

php-cli@8.1: ## Build PHP 8.1 CLI
	@cd php && make cli@8.1

php-cli@8.2: ## Build PHP 8.2 CLI
	@cd php && make cli@8.2

php-cli@8.3: ## Build PHP 8.3 CLI
	@cd php && make cli@8.3

php-cli@8.4: ## Build PHP 8.4 CLI
	@cd php && make cli@8.4

php-fpm@8.1: ## Build PHP 8.1 FPM
	@cd php && make fpm@8.1

php-fpm@8.2: ## Build PHP 8.2 FPM
	@cd php && make fpm@8.2

php-fpm@8.3: ## Build PHP 8.3 FPM
	@cd php && make fpm@8.3

php-fpm@8.4: ## Build PHP 8.4 FPM
	@cd php && make fpm@8.4

php-apache@8.2: ## Build PHP 8.2 Apache
	@cd php && make apache@8.2

php-apache@8.3: ## Build PHP 8.3 Apache
	@cd php && make apache@8.3

php-apache@8.4: ## Build PHP 8.4 Apache
	@cd php && make apache@8.4

php-nginx@8.2: ## Build PHP 8.2 Nginx
	@cd php && make nginx@8.2

php-nginx@8.3: ## Build PHP 8.3 Nginx
	@cd php && make nginx@8.3

php-nginx@8.4: ## Build PHP 8.4 Nginx
	@cd php && make nginx@8.4

php-caddy@8.2: ## Build PHP 8.2 Caddy
	@cd php && make caddy@8.2

php-caddy@8.3: ## Build PHP 8.3 Caddy
	@cd php && make caddy@8.3

php-caddy@8.4: ## Build PHP 8.4 Caddy
	@cd php && make caddy@8.4

php-frankenphp@8.2: ## Build PHP 8.2 FrankenPHP
	@cd php && make frankenphp@8.2

php-frankenphp@8.3: ## Build PHP 8.3 FrankenPHP
	@cd php && make frankenphp@8.3

php-apache@8.2-debug: ## Debug PHP 8.2 Apache
	@cd php && make apache@8.2-debug

php-nginx@8.2-debug: ## Debug PHP 8.2 Nginx
	@cd php && make nginx@8.2-debug

php-caddy@8.2-debug: ## Debug PHP 8.2 Caddy
	@cd php && make caddy@8.2-debug

php-frankenphp@8.2-debug: ## Debug PHP 8.2 FrankenPHP
	@cd php && make frankenphp@8.2-debug

php-build-all: ## Build all PHP images
	@cd php && make build-all

php-clean: ## Clean all PHP images
	@cd php && make clean-all

# ========== REDIS COMMANDS ==========

redis-help: ## Show Redis commands
	@cd redis && make help

redis@6.2: ## Build & test Redis 6.2
	@cd redis && make 6.2

redis@7.0: ## Build & test Redis 7.0
	@cd redis && make 7.0

redis@7.2: ## Build & test Redis 7.2
	@cd redis && make 7.2

redis@7.4: ## Build & test Redis 7.4
	@cd redis && make 7.4

redis-latest: ## Build & test Redis latest
	@cd redis && make latest

redis-build: ## Build Redis latest version
	@cd redis && make build

redis-build-all: ## Build all Redis versions
	@cd redis && make build-all

redis-run: ## Run Redis
	@cd redis && make run

redis-test: ## Test Redis
	@cd redis && make test

redis-stop: ## Stop Redis
	@cd redis && make stop

redis-clean: ## Clean Redis
	@cd redis && make clean

redis-clean-all: ## Clean all Redis
	@cd redis && make clean-all

# ========== GENERAL COMMANDS ==========

build-all: php-build-all redis-build-all ## Build all images (PHP + Redis)

clean-all: php-clean redis-clean-all ## Clean everything

status: ## Show status of all containers
	@echo "$(BLUE)PHP Containers:$(NC)"
	@docker ps -a | grep "php_" || echo "  No PHP containers"
	@echo ""
	@echo "$(BLUE)Redis Containers:$(NC)"
	@docker ps -a | grep "redis" || echo "  No Redis containers"

images: ## List all Adeliom images
	@echo "$(BLUE)Adeliom Images:$(NC)"
	@docker images | grep adeliom || echo "  No images found"

ps: ## Show all running containers
	@docker ps

# ========== LEGACY SUPPORT (for backward compatibility) ==========

# Keep old commands working for backward compatibility
fpm@8.1: php-fpm@8.1
fpm@8.2: php-fpm@8.2
fpm@8.3: php-fpm@8.3
fpm@8.4: php-fpm@8.4
apache@8.2: php-apache@8.2
apache@8.3: php-apache@8.3
apache@8.4: php-apache@8.4
nginx@8.2: php-nginx@8.2
nginx@8.3: php-nginx@8.3
nginx@8.4: php-nginx@8.4
caddy@8.2: php-caddy@8.2
caddy@8.3: php-caddy@8.3
caddy@8.4: php-caddy@8.4
frankenphp@8.2: php-frankenphp@8.2
frankenphp@8.3: php-frankenphp@8.3
apache@8.2-debug: php-apache@8.2-debug
nginx@8.2-debug: php-nginx@8.2-debug
caddy@8.2-debug: php-caddy@8.2-debug
frankenphp@8.2-debug: php-frankenphp@8.2-debug
