# Redis Adeliom Makefile
# Local testing and development commands

.PHONY: help

# Colors for output
BLUE := \033[0;34m
GREEN := \033[0;32m
RED := \033[0;31m
YELLOW := \033[0;33m
NC := \033[0m # No Color

help: ## Show this help message
	@echo "$(BLUE)Redis Adeliom - Available commands:$(NC)"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# Variables
REDIS_VERSION ?= 7.4
IMAGE_NAME := adeliom/redis
CONTAINER_NAME := adeliom_redis_test
REGISTRY ?= docker.io
IMAGE_PREFIX ?= adeliom
TEST_PASSWORD := test123

# ========== BUILD COMMANDS ==========

build: ## Build Redis image locally
	@echo "$(BLUE)Building Redis $(REDIS_VERSION) image...$(NC)"
	docker build \
		--build-arg REDIS_VERSION=$(REDIS_VERSION) \
		-t $(IMAGE_NAME):$(REDIS_VERSION) \
		-t $(IMAGE_NAME):latest \
		-f Dockerfile .
	@echo "$(GREEN)✓ Image built successfully$(NC)"

build-all: ## Build all Redis versions
	@echo "$(BLUE)Building all Redis versions...$(NC)"
	$(MAKE) build REDIS_VERSION=6.2
	$(MAKE) build REDIS_VERSION=7.0
	$(MAKE) build REDIS_VERSION=7.2
	$(MAKE) build REDIS_VERSION=7.4
	@echo "$(GREEN)✓ All images built successfully$(NC)"

build-nc: ## Build without cache
	@echo "$(BLUE)Building Redis $(REDIS_VERSION) without cache...$(NC)"
	docker build \
		--no-cache \
		--build-arg REDIS_VERSION=$(REDIS_VERSION) \
		-t $(IMAGE_NAME):$(REDIS_VERSION) \
		-f Dockerfile .
	@echo "$(GREEN)✓ Image built successfully$(NC)"

# ========== RUN COMMANDS ==========

run: stop ## Run Redis with password
	@echo "$(BLUE)Starting Redis $(REDIS_VERSION) with password...$(NC)"
	docker run -d \
		--name $(CONTAINER_NAME) \
		-e REDIS_PASSWORD=$(TEST_PASSWORD) \
		-p 6379:6379 \
		$(IMAGE_NAME):$(REDIS_VERSION)
	@echo "$(GREEN)✓ Redis started on port 6379$(NC)"
	@echo "$(YELLOW)Password: $(TEST_PASSWORD)$(NC)"

run-no-password: stop ## Run Redis without password (dev mode)
	@echo "$(BLUE)Starting Redis $(REDIS_VERSION) without password...$(NC)"
	@echo "$(YELLOW)⚠️  Development mode only!$(NC)"
	docker run -d \
		--name $(CONTAINER_NAME) \
		-e ALLOW_EMPTY_PASSWORD=yes \
		-p 6379:6379 \
		$(IMAGE_NAME):$(REDIS_VERSION)
	@echo "$(GREEN)✓ Redis started on port 6379$(NC)"

run-debug: stop ## Run Redis in debug mode
	@echo "$(BLUE)Starting Redis $(REDIS_VERSION) in debug mode...$(NC)"
	docker run -it --rm \
		--name $(CONTAINER_NAME) \
		-e REDIS_PASSWORD=$(TEST_PASSWORD) \
		-e MODE_DEBUG=true \
		-p 6379:6379 \
		$(IMAGE_NAME):$(REDIS_VERSION)

run-custom: stop ## Run Redis with custom configuration
	@echo "$(BLUE)Starting Redis $(REDIS_VERSION) with custom config...$(NC)"
	docker run -d \
		--name $(CONTAINER_NAME) \
		-e REDIS_PASSWORD=$(TEST_PASSWORD) \
		-e REDIS_PORT_NUMBER=6379 \
		-e REDIS_DATABASE=16 \
		-e REDIS_AOF_ENABLED=yes \
		-e REDIS_DISABLE_COMMANDS=FLUSHDB,FLUSHALL,CONFIG \
		-p 6379:6379 \
		-v redis_data:/adeliom/redis/data \
		$(IMAGE_NAME):$(REDIS_VERSION)
	@echo "$(GREEN)✓ Redis started with custom configuration$(NC)"

run-prod: stop ## Run Redis with production configuration
	@echo "$(BLUE)Starting Redis $(REDIS_VERSION) with production config...$(NC)"
	docker run -d \
		--name $(CONTAINER_NAME) \
		-e REDIS_PASSWORD=$(TEST_PASSWORD) \
		-e REDIS_DISABLE_COMMANDS=FLUSHDB,FLUSHALL,CONFIG,KEYS,DEBUG \
		-e REDIS_AOF_ENABLED=yes \
		-e REDIS_IO_THREADS=4 \
		-p 6379:6379 \
		-v redis_data:/adeliom/redis/data \
		-v redis_logs:/adeliom/redis/logs \
		-v ./config/redis-prod.conf:/opt/adeliom/redis/redis.conf.default:ro \
		$(IMAGE_NAME):$(REDIS_VERSION)
	@echo "$(GREEN)✓ Redis started with production configuration$(NC)"

# ========== CONTAINER MANAGEMENT ==========

stop: ## Stop Redis container
	@echo "$(BLUE)Stopping Redis container...$(NC)"
	@docker stop $(CONTAINER_NAME) 2>/dev/null || true
	@docker rm $(CONTAINER_NAME) 2>/dev/null || true
	@echo "$(GREEN)✓ Container stopped$(NC)"

restart: stop run ## Restart Redis container

logs: ## Show Redis logs
	@docker logs -f $(CONTAINER_NAME)

shell: ## Open shell in Redis container
	@docker exec -it $(CONTAINER_NAME) /bin/bash

# ========== REDIS CLI COMMANDS ==========

cli: ## Open redis-cli
	@echo "$(BLUE)Opening redis-cli...$(NC)"
	@docker exec -it $(CONTAINER_NAME) redis-cli -a $(TEST_PASSWORD)

cli-no-password: ## Open redis-cli without password
	@docker exec -it $(CONTAINER_NAME) redis-cli

ping: ## Test Redis connection
	@echo "$(BLUE)Testing Redis connection...$(NC)"
	@docker exec $(CONTAINER_NAME) redis-cli -a $(TEST_PASSWORD) --no-auth-warning ping && \
		echo "$(GREEN)✓ Redis is responding$(NC)" || \
		echo "$(RED)✗ Redis is not responding$(NC)"

# ========== TESTING COMMANDS ==========

test: ## Run basic tests
	@echo "$(BLUE)Running basic tests...$(NC)"
	@$(MAKE) test-connection
	@$(MAKE) test-set-get
	@$(MAKE) test-info
	@echo "$(GREEN)✓ All tests passed$(NC)"

test-connection: ## Test Redis connection
	@echo "$(BLUE)Testing connection...$(NC)"
	@docker exec $(CONTAINER_NAME) redis-cli -a $(TEST_PASSWORD) --no-auth-warning ping > /dev/null && \
		echo "$(GREEN)  ✓ Connection test passed$(NC)" || \
		(echo "$(RED)  ✗ Connection test failed$(NC)" && exit 1)

test-set-get: ## Test SET/GET operations
	@echo "$(BLUE)Testing SET/GET operations...$(NC)"
	@docker exec $(CONTAINER_NAME) redis-cli -a $(TEST_PASSWORD) --no-auth-warning SET test_key "Hello Adeliom" > /dev/null
	@VALUE=$$(docker exec $(CONTAINER_NAME) redis-cli -a $(TEST_PASSWORD) --no-auth-warning GET test_key); \
	if [ "$$VALUE" = "Hello Adeliom" ]; then \
		echo "$(GREEN)  ✓ SET/GET test passed$(NC)"; \
	else \
		echo "$(RED)  ✗ SET/GET test failed$(NC)"; \
		exit 1; \
	fi

test-info: ## Test Redis INFO command
	@echo "$(BLUE)Testing INFO command...$(NC)"
	@docker exec $(CONTAINER_NAME) redis-cli -a $(TEST_PASSWORD) --no-auth-warning INFO server | grep redis_version > /dev/null && \
		echo "$(GREEN)  ✓ INFO test passed$(NC)" || \
		(echo "$(RED)  ✗ INFO test failed$(NC)" && exit 1)

test-persistence: ## Test data persistence
	@echo "$(BLUE)Testing data persistence...$(NC)"
	@docker exec $(CONTAINER_NAME) redis-cli -a $(TEST_PASSWORD) --no-auth-warning SET persist_test "data_should_persist" > /dev/null
	@docker restart $(CONTAINER_NAME) > /dev/null
	@sleep 3
	@VALUE=$$(docker exec $(CONTAINER_NAME) redis-cli -a $(TEST_PASSWORD) --no-auth-warning GET persist_test); \
	if [ "$$VALUE" = "data_should_persist" ]; then \
		echo "$(GREEN)  ✓ Persistence test passed$(NC)"; \
	else \
		echo "$(RED)  ✗ Persistence test failed$(NC)"; \
		exit 1; \
	fi

test-all-versions: ## Test all Redis versions
	@echo "$(BLUE)Testing all Redis versions...$(NC)"
	@for version in 6.2 7.0 7.2 7.4; do \
		echo "$(BLUE)Testing Redis $$version...$(NC)"; \
		$(MAKE) build REDIS_VERSION=$$version; \
		$(MAKE) run REDIS_VERSION=$$version; \
		sleep 3; \
		$(MAKE) test REDIS_VERSION=$$version; \
		$(MAKE) stop; \
	done
	@echo "$(GREEN)✓ All versions tested successfully$(NC)"

# ========== INFORMATION COMMANDS ==========

info: ## Show Redis server info
	@docker exec $(CONTAINER_NAME) redis-cli -a $(TEST_PASSWORD) --no-auth-warning INFO

info-server: ## Show server information
	@docker exec $(CONTAINER_NAME) redis-cli -a $(TEST_PASSWORD) --no-auth-warning INFO server

info-memory: ## Show memory information
	@docker exec $(CONTAINER_NAME) redis-cli -a $(TEST_PASSWORD) --no-auth-warning INFO memory

info-stats: ## Show statistics
	@docker exec $(CONTAINER_NAME) redis-cli -a $(TEST_PASSWORD) --no-auth-warning INFO stats

info-replication: ## Show replication information
	@docker exec $(CONTAINER_NAME) redis-cli -a $(TEST_PASSWORD) --no-auth-warning INFO replication

config: ## Show Redis configuration
	@docker exec $(CONTAINER_NAME) cat /adeliom/redis/conf/redis.conf

health: ## Check container health
	@docker inspect --format='{{.State.Health.Status}}' $(CONTAINER_NAME)

# ========== DOCKER COMPOSE COMMANDS ==========

compose-up: ## Start Redis with docker-compose
	@echo "$(BLUE)Starting Redis with docker-compose...$(NC)"
	@cd config && docker-compose -f docker-compose.example.yml up -d redis
	@echo "$(GREEN)✓ Redis started$(NC)"

compose-down: ## Stop docker-compose services
	@echo "$(BLUE)Stopping docker-compose services...$(NC)"
	@cd config && docker-compose -f docker-compose.example.yml down
	@echo "$(GREEN)✓ Services stopped$(NC)"

compose-logs: ## Show docker-compose logs
	@cd config && docker-compose -f docker-compose.example.yml logs -f redis

# ========== CLEANUP COMMANDS ==========

clean: stop ## Clean containers and images
	@echo "$(BLUE)Cleaning containers and images...$(NC)"
	@docker rmi $(IMAGE_NAME):$(REDIS_VERSION) 2>/dev/null || true
	@docker rmi $(IMAGE_NAME):latest 2>/dev/null || true
	@echo "$(GREEN)✓ Cleanup completed$(NC)"

clean-all: ## Clean everything (containers, images, volumes)
	@echo "$(RED)Cleaning everything...$(NC)"
	@docker stop $(CONTAINER_NAME) 2>/dev/null || true
	@docker rm $(CONTAINER_NAME) 2>/dev/null || true
	@docker rmi $(IMAGE_NAME):6.2 2>/dev/null || true
	@docker rmi $(IMAGE_NAME):7.0 2>/dev/null || true
	@docker rmi $(IMAGE_NAME):7.2 2>/dev/null || true
	@docker rmi $(IMAGE_NAME):7.4 2>/dev/null || true
	@docker rmi $(IMAGE_NAME):latest 2>/dev/null || true
	@docker volume rm redis_data 2>/dev/null || true
	@docker volume rm redis_logs 2>/dev/null || true
	@echo "$(GREEN)✓ Full cleanup completed$(NC)"

clean-volumes: ## Clean Redis volumes only
	@echo "$(RED)Cleaning Redis volumes...$(NC)"
	@docker volume rm redis_data 2>/dev/null || true
	@docker volume rm redis_logs 2>/dev/null || true
	@echo "$(GREEN)✓ Volumes cleaned$(NC)"

# ========== RELEASE COMMANDS ==========

tag: ## Tag image for registry
	@echo "$(BLUE)Tagging image $(IMAGE_NAME):$(REDIS_VERSION)...$(NC)"
	docker tag $(IMAGE_NAME):$(REDIS_VERSION) $(REGISTRY)/$(IMAGE_PREFIX)/redis:$(REDIS_VERSION)
	@echo "$(GREEN)✓ Image tagged$(NC)"

push: tag ## Push image to registry
	@echo "$(BLUE)Pushing image to $(REGISTRY)...$(NC)"
	docker push $(REGISTRY)/$(IMAGE_PREFIX)/redis:$(REDIS_VERSION)
	@echo "$(GREEN)✓ Image pushed$(NC)"

release: build-nc push ## Build and push image

# ========== QUICK COMMANDS ==========

6.2: ## Quick build and test Redis 6.2
	@$(MAKE) build REDIS_VERSION=6.2
	@$(MAKE) run REDIS_VERSION=6.2
	@$(MAKE) test REDIS_VERSION=6.2

7.0: ## Quick build and test Redis 7.0
	@$(MAKE) build REDIS_VERSION=7.0
	@$(MAKE) run REDIS_VERSION=7.0
	@$(MAKE) test REDIS_VERSION=7.0

7.2: ## Quick build and test Redis 7.2
	@$(MAKE) build REDIS_VERSION=7.2
	@$(MAKE) run REDIS_VERSION=7.2
	@$(MAKE) test REDIS_VERSION=7.2

7.4: ## Quick build and test Redis 7.4
	@$(MAKE) build REDIS_VERSION=7.4
	@$(MAKE) run REDIS_VERSION=7.4
	@$(MAKE) test REDIS_VERSION=7.4

latest: 7.4 ## Build and test latest version

# ========== DEBUG COMMANDS ==========

inspect: ## Inspect Redis container
	@docker inspect $(CONTAINER_NAME)

ps: ## Show container status
	@docker ps -a | grep $(CONTAINER_NAME) || echo "Container not found"

images: ## List Redis images
	@docker images | grep adeliom/redis

volumes: ## List Redis volumes
	@docker volume ls | grep redis

monitor: ## Monitor Redis commands in real-time
	@echo "$(BLUE)Monitoring Redis commands (Ctrl+C to stop)...$(NC)"
	@docker exec -it $(CONTAINER_NAME) redis-cli -a $(TEST_PASSWORD) --no-auth-warning MONITOR

slowlog: ## Show slow queries
	@echo "$(BLUE)Recent slow queries:$(NC)"
	@docker exec $(CONTAINER_NAME) redis-cli -a $(TEST_PASSWORD) --no-auth-warning SLOWLOG GET 10

# ========== VERSION INFO ==========

version: ## Show Redis version
	@docker exec $(CONTAINER_NAME) redis-cli -a $(TEST_PASSWORD) --no-auth-warning INFO server | grep redis_version
