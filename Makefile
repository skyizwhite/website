TAILWIND_URL=https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-macos-arm64
TAILWIND_TARGET=tailwindcss-macos-arm64
BIN_DIR=./bin
TAILWIND_BIN=$(BIN_DIR)/tailwindcss
STYLE_SRC=./static/style/global.css
STYLE_DIST=./static/style/dist.css

all: install

install: ## Download TailwindCSS binary and install other dependencies
	@echo "Creating bin directory if it doesn't exist..."
	mkdir -p $(BIN_DIR)
	@echo "Downloading TailwindCSS binary..."
	curl -sLO $(TAILWIND_URL)
	@echo "Making TailwindCSS binary executable..."
	chmod +x $(TAILWIND_TARGET)
	@echo "Moving TailwindCSS binary to $(BIN_DIR)..."
	mv $(TAILWIND_TARGET) $(TAILWIND_BIN)
	@echo "TailwindCSS is ready in $(BIN_DIR)/"
	@echo "Installing qlot dependencies..."
	@qlot install

watch: ## Start TailwindCSS in watch mode for automatic rebuilds
	@$(TAILWIND_BIN) -i $(STYLE_SRC) -o $(STYLE_DIST) --watch=always

build: ## Generate the final CSS output
	@$(TAILWIND_BIN) -i $(STYLE_SRC) -o $(STYLE_DIST)

help: ## Display available commands and their descriptions
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

clean: ## Remove the bin directory and clean up generated files
	@echo "Removing $(BIN_DIR)..."
	rm -rf $(BIN_DIR)

lem: ## Open Lem with TailwindCSS server
	@echo "Starting TailwindCSS server in background..."
	@make watch > /dev/null 2>&1 & \
	WATCH_PID=$$!; \
	trap "kill $$WATCH_PID" SIGINT SIGTERM EXIT; \
	lem; \
	kill $$WATCH_PID

docker-build:
	docker build -t hp .

docker-run:
	docker run -p 3000:3000 hp