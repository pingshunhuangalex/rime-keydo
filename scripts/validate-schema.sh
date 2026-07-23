#!/bin/bash
set -euo pipefail

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "${REPO_ROOT}"

BUILD_DIR="build"

if [[ ! -d "${BUILD_DIR}" ]]; then
    echo "🔴 Keydo images directory ${REPO_ROOT}/${BUILD_DIR} not found."
    exit 1
fi

if [ "${1:-}" == "--install-deps" ]; then
    echo "🟣 Installing dependencies..."
    sudo apt-get update -qq
    sudo apt-get install -yqq librime-bin
fi

DEPLOYER=$(command -v rime_deployer || true)

if [ -z "$DEPLOYER" ]; then
    echo "🔴 Dependencies 'rime_deployer' not found." >&2
    exit 1
fi

echo "🟣 Running Keydo schema check via Rime deployer..."
IMAGE_COUNT=0
ERROR_COUNT=0

for image in build/*/; do
    if [[ -d "$image" ]]; then
        IMAGE_COUNT=$((IMAGE_COUNT + 1))

        image_dir="${image%/}"
        image_name=$(basename "$image_dir")
        output_dir="$image_dir/build"

        mkdir -p "$output_dir"

        printf "%-50s" "Compiling $image_name"

        set +e
        # NOTE: Passing "$image_dir" twice as the image built is a fully self-contained schema. No shared data needed
        output=$("$DEPLOYER" --build "$image_dir" "$image_dir" "$output_dir" 2>&1)
        exit_code=$?
        set -e

        if echo "$output" | grep -qE "^E[0-9]" || [ $exit_code -ne 0 ]; then
            echo "FAIL"
            echo "$output" | grep "^E" | sed 's/^/   /' >&2 || echo "$output" | sed 's/^/   /' >&2
            ERROR_COUNT=$((ERROR_COUNT + 1))
        else
            echo "OK"
        fi
    fi
done < <(find build/ -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)

ERROR_LABEL="errors"
[ "$ERROR_COUNT" -eq 1 ] && ERROR_LABEL="error"

IMAGE_LABEL="images"
[ "$IMAGE_COUNT" -eq 1 ] && IMAGE_LABEL="image"

echo ""
echo "Total: $ERROR_COUNT $ERROR_LABEL in $IMAGE_COUNT $IMAGE_LABEL"

if [ $ERROR_COUNT -eq 0 ]; then
    echo "🟢 All Keydo images pass the schema check!"
else
    exit 1
fi
