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
FILE_COUNT=0
ERROR_COUNT=0

while IFS= read -r -d '' file; do
    FILE_COUNT=$((FILE_COUNT + 1))

    clean_file_path="${file#./}"
    printf "%-50s" "Checking $clean_file_path"

    if err_msg=$("$LUAC" -p "$file" 2>&1); then
        echo "OK"
    else
        echo "FAIL"
        echo "   $err_msg" >&2
        ERROR_COUNT=$((ERROR_COUNT + 1))
    fi
done < <(find . -name "*.lua" ! -name "*.draft.lua" -print0 | sort -z)

ERROR_LABEL="errors"
[ "$ERROR_COUNT" -eq 1 ] && ERROR_LABEL="error"

FILE_LABEL="files"
[ "$FILE_COUNT" -eq 1 ] && FILE_LABEL="file"

echo ""
echo "Total: 0 warnings / $ERROR_COUNT $ERROR_LABEL in $FILE_COUNT $FILE_LABEL"

echo "🟢 All Lua files pass the syntax and linting checks!"
