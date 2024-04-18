install: ## Install dependencies
	@qlot install

dev: ## Run dev mode
	@tailwindcss -i ./src/assets/css/global.css -o ./src/assets/css/dist.css --watch

help: ## Show options
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
