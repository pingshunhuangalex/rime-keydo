#!/bin/bash
set -euo pipefail

# Allow installing dependencies specifically for the CI environment
if [ "$1" == "--install-deps" ]; then
    echo "🟣 Installing dependencies..."

    sudo apt-get update > /dev/null 2>&1
    sudo apt-get install -y lua5.3 liblua5.3-dev luarocks build-essential unzip > /dev/null 2>&1
    sudo luarocks install luacheck > /dev/null 2>&1
fi

# Locate the correct Lua compiler (handles variations across OS/environments)
LUAC=$(command -v luac5.3 || command -v luac || echo "")

# Prevent execution if dependencies are missing locally
if ! command -v luacheck &> /dev/null || [ -z "$LUAC" ]; then
    echo "🔴 Dependencies 'luacheck' or 'luac' not found." >&2
    exit 1
fi

echo "🟣 Checking Lua files via Luacheck..."
luacheck lua/ rime.lua \
    --exclude-files "lua/*.draft.lua" \
    --no-color \
    --only 0

echo "🟣 Running strict Lua compilation check using ${LUAC}..."
find . -name "*.lua" ! -name "*.draft.lua" -exec "$LUAC" -p {} \;

echo "🟢 All Lua files pass the syntax and linting checks!"
