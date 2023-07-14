.PHONY: build
build: ## Build containers for first run
	docker compose build --no-cache
	# Start everything
	docker compose up -d

	./bin/rails db:setup
	RAILS_ENV=development ./bin/rails db:fixtures:load

	@echo "Build Succeeded"

.PHONY: logs
logs: ## Displays logs for all running containers
	docker compose logs --follow --timestamps

.PHONY: restart
restart: stop start ## Restart containers

.PHONY: start
start: ## Start development containers in the background
	docker compose up -d

.PHONY: start-fg
start-fg: ## Start development containers
	docker compose up

.PHONY: stop
stop: ## Stop and remove containers
	docker compose down --remove-orphans
