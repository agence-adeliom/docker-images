# HELP
# This will output the help for each task
# IMAGE=php VARIATION=cli PHP_VERSION=8.1 make build 
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

IMAGE_PREFIX=arnaudritti
IMAGE_NAME=$(IMAGE_PREFIX)/$(IMAGE)
DOCKER_REPO=docker.io

# DOCKER TASKS
build: ## Build the container
	$(eval DOCKERFILE := $(IMAGE)/Dockerfile-$(VERSION).$(VARIATION))
ifeq ("$(wildcard $(DOCKERFILE))","")
	$(eval DOCKERFILE := $(IMAGE)/Dockerfile.$(VARIATION))
endif
	docker build -t $(IMAGE_NAME) --build-arg PHP_VERSION=$(VERSION) -f $(DOCKERFILE) $(IMAGE)


build-nc: ## Build the container without caching
	$(eval DOCKERFILE := $(IMAGE)/Dockerfile-$(VERSION).$(VARIATION))
ifeq ("$(wildcard $(DOCKERFILE))","")
	$(eval DOCKERFILE := $(IMAGE)/Dockerfile.$(VARIATION))
endif
	docker build --no-cache -t $(IMAGE_NAME) --build-arg PHP_VERSION=$(VERSION) -f $(DOCKERFILE) $(IMAGE)

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
	@echo 'publish $(VERSION)-$(VARIATION) to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(IMAGE_NAME):$(VERSION)-$(VARIATION)

# Docker tagging
tag: ## Generate container tag
	@echo 'create tag $(VERSION)-$(VARIATION)'
	docker tag $(IMAGE_NAME) $(DOCKER_REPO)/$(IMAGE_NAME):$(VERSION)-$(VARIATION)