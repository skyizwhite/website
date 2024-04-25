install: ## Install dependencies
	@qlot install

dev: ## Run dev mode
	@tailwindcss -i ./public/global.css -o ./public/dist.css --watch=always < /dev/null &

stop: ## Stop dev mode
	@pkill -f tailwind

build: ## Build
	@tailwindcss -i ./public/global.css -o ./public/dist.css

help: ## Show options
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
