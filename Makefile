install: ## Install dependencies
	@qlot install ; npm i

css: ## Scan and build tailwindcss
	@npx tailwindcss -o ./static/tailwind.css --watch

help: ## Show options
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
