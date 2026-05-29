tw_version := "4.3.0"
tw_bin     := "./bin/tailwindcss"
style_src  := "./assets/style/global.css"
style_dist := "./assets/style/dist.css"

tw_platform := "linux-x64"

[private]
default:
    @just --list

# Download TailwindCSS binary and install other dependencies
install:
    @echo "Creating bin directory if it doesn't exist..."
    mkdir -p ./bin
    @echo "Downloading TailwindCSS binary..."
    curl -sLo {{ tw_bin }} https://github.com/tailwindlabs/tailwindcss/releases/download/v{{ tw_version }}/tailwindcss-{{ tw_platform }}
    @echo "Making TailwindCSS binary executable..."
    chmod +x {{ tw_bin }}
    @echo "TailwindCSS is ready in {{ tw_bin }}"
    @echo "Installing qlot dependencies..."
    @qlot install

# Start TailwindCSS in watch mode for automatic rebuilds
watch:
    @{{ tw_bin }} -i {{ style_src }} -o {{ style_dist }} --watch=always

# Generate the final CSS output
build:
    @{{ tw_bin }} -i {{ style_src }} -o {{ style_dist }}

# Remove the bin directory and clean up generated files
clean:
    @echo "Removing ./bin..."
    rm -rf ./bin
    @echo "Removing qlot dependencies..."
    rm -rf ./.qlot/

# Open Lem with TailwindCSS server
lem:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "Starting TailwindCSS server in background..."
    just watch > /dev/null 2>&1 &
    WATCH_PID=$!
    trap "kill $WATCH_PID" SIGINT SIGTERM EXIT
    lem
