# PHP Adeliom Makefile
# Local testing and development commands

.PHONY: help

# Colors for output
BLUE := \033[0;34m
GREEN := \033[0;32m
RED := \033[0;31m
YELLOW := \033[0;33m
NC := \033[0m # No Color

help: ## Show this help message
	@echo "$(BLUE)PHP Adeliom - Available commands:$(NC)"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_@.-]+:.*?## / {printf "  $(GREEN)%-25s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# Variables
PHP_VERSION ?= 8.4
VARIATION ?= cli
IMAGE_NAME := adeliom/php
REGISTRY ?= docker.io
IMAGE_PREFIX ?= adeliom
TEST_DIR := ../test

# ========== BUILD COMMANDS ==========

build: ## Build PHP image locally
	@echo "$(BLUE)Building PHP $(PHP_VERSION)-$(VARIATION)...$(NC)"
	$(eval DOCKERFILE := Dockerfile.$(VARIATION))
	docker build \
		--build-arg PHP_VERSION=$(PHP_VERSION) \
		--build-arg REGISTRY=$(REGISTRY) \
		-t $(IMAGE_NAME):$(PHP_VERSION)-$(VARIATION) \
		-f $(DOCKERFILE) .
	@echo "$(GREEN)✓ Image built successfully$(NC)"

build-nc: ## Build without cache
	@echo "$(BLUE)Building PHP $(PHP_VERSION)-$(VARIATION) without cache...$(NC)"
	$(eval DOCKERFILE := Dockerfile.$(VARIATION))
	docker build \
		--no-cache \
		--build-arg PHP_VERSION=$(PHP_VERSION) \
		--build-arg REGISTRY=$(REGISTRY) \
		-t $(IMAGE_NAME):$(PHP_VERSION)-$(VARIATION) \
		-f $(DOCKERFILE) .
	@echo "$(GREEN)✓ Image built successfully$(NC)"

build-all-variants: ## Build all variants for a specific PHP version
	@echo "$(BLUE)Building all variants for PHP $(PHP_VERSION)...$(NC)"
	@for variant in cli fpm apache nginx caddy frankenphp; do \
		if [ -f "Dockerfile.$$variant" ]; then \
			$(MAKE) build VARIATION=$$variant PHP_VERSION=$(PHP_VERSION); \
		fi \
	done
	@echo "$(GREEN)✓ All variants built$(NC)"

build-all: ## Build all PHP versions and variants
	@echo "$(BLUE)Building all PHP versions and variants...$(NC)"
	@for version in 8.1 8.2 8.3 8.4; do \
		for variant in cli fpm apache nginx caddy frankenphp; do \
			if [ -f "Dockerfile.$$variant" ]; then \
				$(MAKE) build PHP_VERSION=$$version VARIATION=$$variant; \
			fi \
		done \
	done
	@echo "$(GREEN)✓ All images built$(NC)"

# ========== RUN COMMANDS ==========

run: stop ## Run PHP container
	@echo "$(BLUE)Starting PHP $(PHP_VERSION)-$(VARIATION)...$(NC)"
	@if [ "$(VARIATION)" = "cli" ] || [ "$(VARIATION)" = "fpm" ]; then \
		docker run -d \
			--name php_$(PHP_VERSION)_$(VARIATION) \
			-v $(TEST_DIR):/var/www/html \
			$(IMAGE_NAME):$(PHP_VERSION)-$(VARIATION); \
	else \
		docker run -d \
			--name php_$(PHP_VERSION)_$(VARIATION) \
			-p 8080:80 \
			-v $(TEST_DIR):/var/www/html \
			$(IMAGE_NAME):$(PHP_VERSION)-$(VARIATION); \
		echo "$(GREEN)✓ Server started on http://localhost:8080$(NC)"; \
	fi

run-debug: stop ## Run PHP container in interactive mode
	@echo "$(BLUE)Starting PHP $(PHP_VERSION)-$(VARIATION) in debug mode...$(NC)"
	@if [ "$(VARIATION)" = "cli" ] || [ "$(VARIATION)" = "fpm" ]; then \
		docker run -it --rm \
			--name php_$(PHP_VERSION)_$(VARIATION) \
			-v $(TEST_DIR):/var/www/html \
			$(IMAGE_NAME):$(PHP_VERSION)-$(VARIATION) /bin/bash; \
	else \
		docker run -it --rm \
			--name php_$(PHP_VERSION)_$(VARIATION) \
			-p 8080:80 \
			-v $(TEST_DIR):/var/www/html \
			$(IMAGE_NAME):$(PHP_VERSION)-$(VARIATION); \
	fi

# ========== CONTAINER MANAGEMENT ==========

stop: ## Stop PHP container
	@docker stop php_$(PHP_VERSION)_$(VARIATION) 2>/dev/null || true
	@docker rm php_$(PHP_VERSION)_$(VARIATION) 2>/dev/null || true

restart: stop run ## Restart container

logs: ## Show container logs
	@docker logs -f php_$(PHP_VERSION)_$(VARIATION)

shell: ## Open shell in container
	@docker exec -it php_$(PHP_VERSION)_$(VARIATION) /bin/bash

# ========== TESTING COMMANDS ==========

test: ## Run PHP tests
	@echo "$(BLUE)Testing PHP $(PHP_VERSION)-$(VARIATION)...$(NC)"
	@$(MAKE) test-version
	@$(MAKE) test-extensions
	@echo "$(GREEN)✓ All tests passed$(NC)"

test-version: ## Test PHP version
	@echo "$(BLUE)Testing PHP version...$(NC)"
	@docker run --rm $(IMAGE_NAME):$(PHP_VERSION)-$(VARIATION) php -v | grep "PHP $(PHP_VERSION)" && \
		echo "$(GREEN)  ✓ PHP version correct$(NC)" || \
		(echo "$(RED)  ✗ PHP version test failed$(NC)" && exit 1)

test-extensions: ## Test PHP extensions
	@echo "$(BLUE)Testing PHP extensions...$(NC)"
	@docker run --rm $(IMAGE_NAME):$(PHP_VERSION)-$(VARIATION) php -m | grep -q "redis" && \
		echo "$(GREEN)  ✓ Redis extension installed$(NC)" || \
		(echo "$(YELLOW)  ! Redis extension not found$(NC)"; exit 0)

test-composer: ## Test Composer
	@echo "$(BLUE)Testing Composer...$(NC)"
	@docker run --rm $(IMAGE_NAME):$(PHP_VERSION)-$(VARIATION) composer --version && \
		echo "$(GREEN)  ✓ Composer working$(NC)" || \
		(echo "$(RED)  ✗ Composer test failed$(NC)" && exit 1)

test-server: ## Test web server (for server variants)
	@echo "$(BLUE)Testing web server...$(NC)"
	@$(MAKE) run
	@sleep 3
	@curl -s http://localhost:8080 > /dev/null && \
		echo "$(GREEN)  ✓ Server responding$(NC)" || \
		(echo "$(RED)  ✗ Server not responding$(NC)" && exit 1)
	@$(MAKE) stop

# ========== PHP SPECIFIC COMMANDS ==========

php-info: ## Show PHP info
	@docker run --rm $(IMAGE_NAME):$(PHP_VERSION)-$(VARIATION) php -i

php-modules: ## List PHP modules
	@docker run --rm $(IMAGE_NAME):$(PHP_VERSION)-$(VARIATION) php -m

php-config: ## Show PHP configuration
	@docker run --rm $(IMAGE_NAME):$(PHP_VERSION)-$(VARIATION) php --ini

composer-version: ## Show Composer version
	@docker run --rm $(IMAGE_NAME):$(PHP_VERSION)-$(VARIATION) composer --version

# ========== QUICK BUILD SHORTCUTS ==========

cli@8.1: ## Build PHP 8.1 CLI
	@$(MAKE) build PHP_VERSION=8.1 VARIATION=cli

cli@8.2: ## Build PHP 8.2 CLI
	@$(MAKE) build PHP_VERSION=8.2 VARIATION=cli

cli@8.3: ## Build PHP 8.3 CLI
	@$(MAKE) build PHP_VERSION=8.3 VARIATION=cli

cli@8.4: ## Build PHP 8.4 CLI
	@$(MAKE) build PHP_VERSION=8.4 VARIATION=cli

fpm@8.1: ## Build PHP 8.1 FPM
	@$(MAKE) build PHP_VERSION=8.1 VARIATION=fpm

fpm@8.2: ## Build PHP 8.2 FPM
	@$(MAKE) build PHP_VERSION=8.2 VARIATION=fpm

fpm@8.3: ## Build PHP 8.3 FPM
	@$(MAKE) build PHP_VERSION=8.3 VARIATION=fpm

fpm@8.4: ## Build PHP 8.4 FPM
	@$(MAKE) build PHP_VERSION=8.4 VARIATION=fpm

apache@8.2: ## Build PHP 8.2 Apache
	@$(MAKE) build PHP_VERSION=8.2 VARIATION=apache

apache@8.3: ## Build PHP 8.3 Apache
	@$(MAKE) build PHP_VERSION=8.3 VARIATION=apache

apache@8.4: ## Build PHP 8.4 Apache
	@$(MAKE) build PHP_VERSION=8.4 VARIATION=apache

nginx@8.2: ## Build PHP 8.2 Nginx
	@$(MAKE) build PHP_VERSION=8.2 VARIATION=nginx

nginx@8.3: ## Build PHP 8.3 Nginx
	@$(MAKE) build PHP_VERSION=8.3 VARIATION=nginx

nginx@8.4: ## Build PHP 8.4 Nginx
	@$(MAKE) build PHP_VERSION=8.4 VARIATION=nginx

caddy@8.2: ## Build PHP 8.2 Caddy
	@$(MAKE) build PHP_VERSION=8.2 VARIATION=caddy

caddy@8.3: ## Build PHP 8.3 Caddy
	@$(MAKE) build PHP_VERSION=8.3 VARIATION=caddy

caddy@8.4: ## Build PHP 8.4 Caddy
	@$(MAKE) build PHP_VERSION=8.4 VARIATION=caddy

frankenphp@8.2: ## Build PHP 8.2 FrankenPHP
	@$(MAKE) build PHP_VERSION=8.2 VARIATION=frankenphp

frankenphp@8.3: ## Build PHP 8.3 FrankenPHP
	@$(MAKE) build PHP_VERSION=8.3 VARIATION=frankenphp

# ========== DEBUG SHORTCUTS ==========

apache@8.2-debug: ## Run PHP 8.2 Apache in debug mode
	@$(MAKE) build PHP_VERSION=8.2 VARIATION=apache
	@$(MAKE) run-debug PHP_VERSION=8.2 VARIATION=apache

nginx@8.2-debug: ## Run PHP 8.2 Nginx in debug mode
	@$(MAKE) build PHP_VERSION=8.2 VARIATION=nginx
	@$(MAKE) run-debug PHP_VERSION=8.2 VARIATION=nginx

caddy@8.2-debug: ## Run PHP 8.2 Caddy in debug mode
	@$(MAKE) build PHP_VERSION=8.2 VARIATION=caddy
	@$(MAKE) run-debug PHP_VERSION=8.2 VARIATION=caddy

frankenphp@8.2-debug: ## Run PHP 8.2 FrankenPHP in debug mode
	@$(MAKE) build PHP_VERSION=8.2 VARIATION=frankenphp
	@$(MAKE) run-debug PHP_VERSION=8.2 VARIATION=frankenphp

# ========== CLEANUP COMMANDS ==========

clean: stop ## Clean current variant
	@echo "$(BLUE)Cleaning PHP $(PHP_VERSION)-$(VARIATION)...$(NC)"
	@docker rmi $(IMAGE_NAME):$(PHP_VERSION)-$(VARIATION) 2>/dev/null || true
	@echo "$(GREEN)✓ Cleanup completed$(NC)"

clean-version: ## Clean all variants for a PHP version
	@echo "$(BLUE)Cleaning all variants for PHP $(PHP_VERSION)...$(NC)"
	@for variant in cli fpm apache nginx caddy frankenphp; do \
		docker rmi $(IMAGE_NAME):$(PHP_VERSION)-$$variant 2>/dev/null || true; \
	done
	@echo "$(GREEN)✓ Cleanup completed$(NC)"

clean-all: ## Clean all PHP images
	@echo "$(RED)Cleaning all PHP images...$(NC)"
	@docker images | grep "adeliom/php" | awk '{print $$3}' | xargs docker rmi -f 2>/dev/null || true
	@echo "$(GREEN)✓ Full cleanup completed$(NC)"

# ========== RELEASE COMMANDS ==========

tag: ## Tag image for registry
	@echo "$(BLUE)Tagging $(IMAGE_NAME):$(PHP_VERSION)-$(VARIATION)...$(NC)"
	docker tag $(IMAGE_NAME):$(PHP_VERSION)-$(VARIATION) $(REGISTRY)/$(IMAGE_PREFIX)/php:$(PHP_VERSION)-$(VARIATION)
	@echo "$(GREEN)✓ Image tagged$(NC)"

push: tag ## Push image to registry
	@echo "$(BLUE)Pushing to $(REGISTRY)...$(NC)"
	docker push $(REGISTRY)/$(IMAGE_PREFIX)/php:$(PHP_VERSION)-$(VARIATION)
	@echo "$(GREEN)✓ Image pushed$(NC)"

release: build-nc push ## Build and push image

# ========== INFORMATION COMMANDS ==========

images: ## List PHP images
	@docker images | grep adeliom/php || echo "No images found"

ps: ## Show running PHP containers
	@docker ps -a | grep php_ || echo "No containers found"

inspect: ## Inspect container
	@docker inspect php_$(PHP_VERSION)_$(VARIATION)

# ========== EXAMPLES ==========

example-apache: ## Example: Build and run Apache
	@echo "$(BLUE)Example: Building and running PHP 8.3 Apache$(NC)"
	@$(MAKE) build PHP_VERSION=8.3 VARIATION=apache
	@$(MAKE) run PHP_VERSION=8.3 VARIATION=apache
	@echo "$(GREEN)Visit: http://localhost:8080$(NC)"

example-cli: ## Example: Build and test CLI
	@echo "$(BLUE)Example: Building and testing PHP 8.4 CLI$(NC)"
	@$(MAKE) build PHP_VERSION=8.4 VARIATION=cli
	@docker run --rm $(IMAGE_NAME):8.4-cli php -v
