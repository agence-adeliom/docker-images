# HELP
# This will output the help for each task
# Github packages Version
# IMAGE=php VARIATION=cli PHP_VERSION=8.2 VERSION=8.2 REGISTRY=ghcr.io/agence-adeliom IMAGE_PREFIX=php make build-local
# Docker Hub Version
# IMAGE=php VARIATION=cli PHP_VERSION=8.2 VERSION=8.2 REGISTRY=docker.io/adeliom IMAGE_PREFIX=adeliom make build-local
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

IMAGE_NAME=$(IMAGE_PREFIX)/$(IMAGE)
TAG_VERSION="-dev"

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
	--tag $(IMAGE_NAME):$(VERSION)-$(VARIATION)$(TAG_VERSION) \
	--build-arg PHP_VERSION=$(VERSION) \
	--build-arg REGISTRY=$(REGISTRY) \
	--build-arg TAG_VERSION=$(TAG_VERSION) \
	--file $(DOCKERFILE) $(IMAGE) \
	--cache-from=type=registry,ref=$(REGISTRY)$(IMAGE_NAME):$(VERSION)-$(VARIATION)$(TAG_VERSION)


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
	--tag $(REGISTRY)$(IMAGE_NAME):$(VERSION)-$(VARIATION)$(TAG_VERSION) \
	--build-arg PHP_VERSION=$(VERSION) \
	--build-arg REGISTRY=$(REGISTRY) \
	--build-arg TAG_VERSION=$(TAG_VERSION) \
	--file $(DOCKERFILE) $(IMAGE) \
	--cache-from=type=registry,ref=$(REGISTRY)$(IMAGE_NAME):$(VERSION)-$(VARIATION)$(TAG_VERSION)

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
	@echo 'publish $(VERSION)-$(VARIATION)$(TAG_VERSION)'
	docker push $(REGISTRY)$(IMAGE_NAME):$(VERSION)-$(VARIATION)$(TAG_VERSION)

# Docker tagging
tag: ## Generate container tag
	@echo 'create tag $(VERSION)-$(VARIATION)$(TAG_VERSION)'
	docker tag $(IMAGE_NAME) $(REGISTRY)$(IMAGE_NAME):$(VERSION)-$(VARIATION)$(TAG_VERSION)

fpm@8.2:
	IMAGE=php VERSION=8.4 VARIATION=fpm REGISTRY=docker.io/adeliom IMAGE_PREFIX=adeliom $(MAKE) build-local

caddy@8.2:
	IMAGE=php VERSION=8.2 VARIATION=caddy REGISTRY=docker.io/adeliom IMAGE_PREFIX=adeliom $(MAKE) build-local

apache@8.2:
	IMAGE=php VERSION=8.2 VARIATION=apache REGISTRY=docker.io/adeliom IMAGE_PREFIX=adeliom $(MAKE) build-local

nginx@8.2:
	IMAGE=php VERSION=8.2 VARIATION=nginx REGISTRY=docker.io/adeliom IMAGE_PREFIX=adeliom $(MAKE) build-local

frankenphp@8.2:
	IMAGE=php VERSION=8.2 VARIATION=frankenphp REGISTRY=docker.io/adeliom IMAGE_PREFIX=adeliom $(MAKE) build-local

caddy@8.2-debug:
	$(eval IMAGE := php)
	$(eval IMAGE_PREFIX := adeliom)
	$(eval VERSION := 8.4)
	$(eval VARIATION := caddy)
	$(eval IMAGE_NAME := $(IMAGE_PREFIX)/$(IMAGE):$(VERSION)-$(VARIATION))
	@docker stop $(IMAGE)_$(VERSION)-$(VARIATION) || true
	@docker run -i -t --rm -p 1234:80 -v ./test/:/var/www/html/ --name="$(IMAGE)_$(VERSION)-$(VARIATION)" $(IMAGE_NAME)

apache@8.2-debug:
	$(eval IMAGE := php)
	$(eval IMAGE_PREFIX := adeliom)
	$(eval VERSION := 8.2)
	$(eval VARIATION := apache)
	$(eval IMAGE_NAME := $(IMAGE_PREFIX)/$(IMAGE):$(VERSION)-$(VARIATION))
	@docker stop $(IMAGE)_$(VERSION)-$(VARIATION) || true
	@docker run -i -t --rm -p 1234:80 -v ./test/:/var/www/html/ --name="$(IMAGE)_$(VERSION)-$(VARIATION)" $(IMAGE_NAME)

nginx@8.2-debug:
	$(eval IMAGE := php)
	$(eval IMAGE_PREFIX := adeliom)
	$(eval VERSION := 8.2)
	$(eval VARIATION := nginx)
	$(eval IMAGE_NAME := $(IMAGE_PREFIX)/$(IMAGE):$(VERSION)-$(VARIATION))
	@docker stop $(IMAGE)_$(VERSION)-$(VARIATION) || true
	@docker run -i -t --rm -p 1234:80 -v ./test/:/var/www/html/ --name="$(IMAGE)_$(VERSION)-$(VARIATION)" $(IMAGE_NAME)

frankenphp@8.2-debug:
	$(eval IMAGE := php)
	$(eval IMAGE_PREFIX := adeliom)
	$(eval VERSION := 8.2)
	$(eval VARIATION := frankenphp)
	$(eval IMAGE_NAME := $(IMAGE_PREFIX)/$(IMAGE):$(VERSION)-$(VARIATION))
	@docker stop $(IMAGE)_$(VERSION)-$(VARIATION) || true
	@docker run -i -t --rm -p 1234:80 -v ./test/:/var/www/html/ --name="$(IMAGE)_$(VERSION)-$(VARIATION)" $(IMAGE_NAME)

frankenphp@8.2-worker-debug:
	$(eval IMAGE := php)
	$(eval IMAGE_PREFIX := adeliom)
	$(eval VERSION := 8.2)
	$(eval VARIATION := frankenphp)
	$(eval IMAGE_NAME := $(IMAGE_PREFIX)/$(IMAGE):$(VERSION)-$(VARIATION))
	@docker stop $(IMAGE)_$(VERSION)-$(VARIATION) || true
	@docker run -i -t --rm -p 1234:80 -v ./test/:/var/www/html/ -e FRANKENPHP_CONFIG="worker /var/www/html/index.php" -e FRANKENPHP_WORKER=true --name="$(IMAGE)_$(VERSION)-$(VARIATION)" $(IMAGE_NAME)
