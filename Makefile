# HELP
# This will output the help for each task
# IMAGE=php VARIATION=cli PHP_VERSION=8.1 make build 
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

IMAGE_PREFIX=adeliom
IMAGE_NAME=$(IMAGE_PREFIX)/$(IMAGE)
REGISTRY=

# DOCKER TASKS
build: ## Build the container
	$(eval DOCKERFILE := $(IMAGE)/Dockerfile-$(VERSION).$(VARIATION))
ifeq ("$(wildcard $(DOCKERFILE))","")
	$(eval DOCKERFILE := $(IMAGE)/Dockerfile.$(VARIATION))
endif
	docker buildx create --use
	docker buildx build \
	--push \
	--platform linux/amd64,linux/arm64 \
	--tag $(IMAGE_NAME):$(VERSION)-$(VARIATION) \
	--build-arg PHP_VERSION=$(VERSION) \
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
	--platform linux/amd64,linux/arm64 \
	--tag $(REGISTRY)$(IMAGE_NAME):$(VERSION)-$(VARIATION) \
	--build-arg PHP_VERSION=$(VERSION) \
	--file $(DOCKERFILE) $(IMAGE) \
	--cache-from=type=registry,ref=$(REGISTRY)$(IMAGE_NAME):$(VERSION)-$(VARIATION)

# Run containers
run: stop ## Run container
	docker run -i -t --rm --name="$(IMAGE_NAME)" $(IMAGE_NAME)

stop: ## Stop running containers
	docker stop $(IMAGE_NAME)

rm: stop ## Stop and remove running containers
	docker rm $(IMAGE_NAME)

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