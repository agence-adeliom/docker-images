# HELP
# This will output the help for each task
# IMAGE=php VARIATION=cli PHP_VERSION=8.2 VERSION=8.2 REGISTRY=ghcr.io/agence-adeliom make build-local
# IMAGE=php VARIATION=cli PHP_VERSION=8.2 VERSION=8.2 REGISTRY=adeliom make build-local
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

IMAGE_PREFIX=php
IMAGE_NAME=$(IMAGE_PREFIX)/$(IMAGE)

# DOCKER TASKS
build: ## Build the container
	$(eval DOCKERFILE := $(IMAGE)/Dockerfile-$(VERSION).$(VARIATION))
ifeq ("$(wildcard $(DOCKERFILE))","")
	$(eval DOCKERFILE := $(IMAGE)/Dockerfile.$(VARIATION))
endif
	docker buildx create --use
	docker buildx build \
	--push \
	--platform linux/amd64 \
	--tag $(IMAGE_NAME):$(VERSION)-$(VARIATION) \
	--build-arg PHP_VERSION=$(VERSION) \
	--build-arg REGISTRY=$(REGISTRY) \
	--file $(DOCKERFILE) $(IMAGE) \
	--cache-from=type=registry,ref=$(REGISTRY)$(IMAGE_NAME):$(VERSION)-$(VARIATION)


build-nc: ## Build the container without caching
	$(eval DOCKERFILE := $(IMAGE)/Dockerfile-$(VERSION).$(VARIATION))
ifeq ("$(wildcard $(DOCKERFILE))","")
	$(eval DOCKERFILE := $(IMAGE)/Dockerfile.$(VARIATION))
endif
	docker buildx create --use
	docker buildx build \
	--push \
	--no-cache \
	--platform linux/amd64 \
	--tag $(REGISTRY)$(IMAGE_NAME):$(VERSION)-$(VARIATION) \
	--build-arg PHP_VERSION=$(VERSION) \
	--build-arg REGISTRY=$(REGISTRY) \
	--file $(DOCKERFILE) $(IMAGE) \
	--cache-from=type=registry,ref=$(REGISTRY)$(IMAGE_NAME):$(VERSION)-$(VARIATION)

build-local: ## Build the container
	$(eval DOCKERFILE := $(IMAGE)/Dockerfile-$(VERSION).$(VARIATION))
ifeq ("$(wildcard $(DOCKERFILE))","")
	$(eval DOCKERFILE := $(IMAGE)/Dockerfile.$(VARIATION))
endif
	docker buildx create --use
	docker buildx build \
	--load \
	--platform linux/amd64 \
	--tag $(IMAGE_NAME):$(VERSION)-$(VARIATION) \
	--build-arg PHP_VERSION=$(VERSION) \
	--build-arg REGISTRY=$(REGISTRY) \
	--file $(DOCKERFILE) $(IMAGE)

# Run containers
run: stop ## Run container
	@docker run -i -t --rm --name="$(IMAGE_NAME)" $(IMAGE_NAME)

stop: ## Stop running containers
	@docker stop $(IMAGE_NAME)

rm: stop ## Stop and remove running containers
	@docker rm $(IMAGE_NAME)

# Docker release - build, tag and push the container
release: build-nc publish ## Make a release by building and publishing the tagged container

# Docker publish
publish: tag ## publish the taged container
	@echo 'publish $(VERSION)-$(VARIATION)'
	docker push $(REGISTRY)$(IMAGE_NAME):$(VERSION)-$(VARIATION)

# Docker tagging
tag: ## Generate container tag
	@echo 'create tag $(VERSION)-$(VARIATION)'
	docker tag $(IMAGE_NAME) $(REGISTRY)$(IMAGE_NAME):$(VERSION)-$(VARIATION)

fpm@8.4:
	IMAGE=php VERSION=8.4 VARIATION=fpm $(MAKE) build-local

caddy@8.2:
	IMAGE=php VERSION=8.2 VARIATION=caddy $(MAKE) build-local

apache@8.2:
	IMAGE=php VERSION=8.2 VARIATION=apache $(MAKE) build-local

nginx@8.2:
	IMAGE=php VERSION=8.2 VARIATION=nginx $(MAKE) build-local

frankenphp@8.2:
	IMAGE=php VERSION=8.2 VARIATION=frankenphp $(MAKE) build-local

caddy@8.2-debug:
	$(eval IMAGE := php)
	$(eval VERSION := 8.2)
	$(eval VARIATION := caddy)
	$(eval IMAGE_NAME := $(IMAGE_PREFIX)/$(IMAGE):$(VERSION)-$(VARIATION))
	@docker stop $(IMAGE)_$(VERSION)-$(VARIATION) || true
	@docker run -i -t --rm -p 1234:80 -v ./test/:/var/www/html/ --name="$(IMAGE)_$(VERSION)-$(VARIATION)" $(IMAGE_NAME)

apache@8.2-debug:
	$(eval IMAGE := php)
	$(eval VERSION := 8.2)
	$(eval VARIATION := apache)
	$(eval IMAGE_NAME := $(IMAGE_PREFIX)/$(IMAGE):$(VERSION)-$(VARIATION))
	@docker stop $(IMAGE)_$(VERSION)-$(VARIATION) || true
	@docker run -i -t --rm -p 1234:80 -v ./test/:/var/www/html/ --name="$(IMAGE)_$(VERSION)-$(VARIATION)" $(IMAGE_NAME)

nginx@8.2-debug:
	$(eval IMAGE := php)
	$(eval VERSION := 8.2)
	$(eval VARIATION := nginx)
	$(eval IMAGE_NAME := $(IMAGE_PREFIX)/$(IMAGE):$(VERSION)-$(VARIATION))
	@docker stop $(IMAGE)_$(VERSION)-$(VARIATION) || true
	@docker run -i -t --rm -p 1234:80 -v ./test/:/var/www/html/ --name="$(IMAGE)_$(VERSION)-$(VARIATION)" $(IMAGE_NAME)

frankenphp@8.2-debug:
	$(eval IMAGE := php)
	$(eval VERSION := 8.2)
	$(eval VARIATION := frankenphp)
	$(eval IMAGE_NAME := $(IMAGE_PREFIX)/$(IMAGE):$(VERSION)-$(VARIATION))
	@docker stop $(IMAGE)_$(VERSION)-$(VARIATION) || true
	@docker run -i -t --rm -p 1234:80 -v ./test/:/var/www/html/ --name="$(IMAGE)_$(VERSION)-$(VARIATION)" $(IMAGE_NAME)

frankenphp@8.2-worker-debug:
	$(eval IMAGE := php)
	$(eval VERSION := 8.2)
	$(eval VARIATION := frankenphp)
	$(eval IMAGE_NAME := $(IMAGE_PREFIX)/$(IMAGE):$(VERSION)-$(VARIATION))
	@docker stop $(IMAGE)_$(VERSION)-$(VARIATION) || true
	@docker run -i -t --rm -p 1234:80 -v ./test/:/var/www/html/ -e FRANKENPHP_CONFIG="worker /var/www/html/index.php" -e FRANKENPHP_WORKER=true --name="$(IMAGE)_$(VERSION)-$(VARIATION)" $(IMAGE_NAME)
