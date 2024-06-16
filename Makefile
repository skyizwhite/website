install: ## Install dependencies
	@qlot install

watch: ## Run watch mode
	@bun run tailwindcss -i ./public/style.css -o ./public/dist.css --watch=always

build: ## Build
	@bun run tailwindcss -i ./public/style.css -o ./public/dist.css

help: ## Show options
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'