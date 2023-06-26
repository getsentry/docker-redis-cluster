help:
	@echo "Please use 'make <target>' where <target> is one of"
	@echo "  build         builds docker-compose containers"
	@echo "  up            starts docker-compose containers"
	@echo "  down          stops the running docker-compose containers"
	@echo "  rebuild       rebuilds the image from scratch without using any cached layers"
	@echo "  bash          starts bash inside a running container."
	@echo "  cli           run redis-cli inside the container on the server with port 7000"

build:
	docker buildx build --output type=docker --build-arg redis_version=7.0.10 --platform linux/arm64 --tag beezz/redis-cluster:7.0.10-arm64 .
	docker buildx build --output type=docker --build-arg redis_version=7.0.10 --platform linux/amd64 --tag beezz/redis-cluster:7.0.10-amd64 .
	docker manifest create beezz/redis-cluster:7.0.10 --amend beezz/redis-cluster:7.0.10-amd64 --amend beezz/redis-cluster:7.0.10-arm64

push:
	docker manifest push --purge beezz/redis-cluster:7.0.10

up:
	@echo "Ensure that you have run `make build` to use the latest image"
	docker-compose up

down:
	docker-compose stop

rebuild:
	docker-compose build --no-cache

bash:
	docker-compose exec redis-cluster /bin/bash

cli:
	docker-compose exec redis-cluster /redis/src/redis-cli -p 7000
