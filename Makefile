TW_VERSION=4.1.3
TW_BIN=./bin/tailwindcss
STYLE_SRC=./static/style/global.css
STYLE_DIST=./static/style/dist.css

UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Darwin)
  TW_PLATFORM := macos-arm64
else ifeq ($(UNAME_S),Linux)
  TW_PLATFORM := linux-x64
else
  $(error "Unsupported OS: $(UNAME_S)")
endif

all: install

install: ## Download TailwindCSS binary and install other dependencies
	@echo "Creating bin directory if it doesn't exist..."
	mkdir -p ./bin
	@echo "Downloading TailwindCSS binary..."
	curl -sLo $(TW_BIN) https://github.com/tailwindlabs/tailwindcss/releases/download/v$(TW_VERSION)/tailwindcss-$(TW_PLATFORM)
	@echo "Making TailwindCSS binary executable..."
	chmod +x $(TW_BIN)
	@echo "TailwindCSS is ready in $(TW_BIN)"
	@echo "Installing qlot dependencies..."
	@qlot install

watch: ## Start TailwindCSS in watch mode for automatic rebuilds
	@$(TW_BIN) -i $(STYLE_SRC) -o $(STYLE_DIST) --watch=always

build: ## Generate the final CSS output
	@$(TW_BIN) -i $(STYLE_SRC) -o $(STYLE_DIST)

help: ## Display available commands and their descriptions
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

clean: ## Remove the bin directory and clean up generated files
	@echo "Removing ./bin..."
	rm -rf ./bin
	@echo "Removing qlot dependencies..."
	rm -rf ./.qlot/

lem: ## Open Lem with TailwindCSS server
	@echo "Starting TailwindCSS server in background..."
	@make watch > /dev/null 2>&1 & \
	WATCH_PID=$$!; \
	trap "kill $$WATCH_PID" SIGINT SIGTERM EXIT; \
	lem; \
	kill $$WATCH_PID

docker-build: ## Build docker image
	docker build -t hp .

docker-run: ## Run docker container
	docker run -p 3000:3000 hp