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
    sudo apt-get update > /dev/null 2>&1
    sudo apt-get install -y librime-bin librime-data > /dev/null 2>&1
fi

DEPLOYER=$(command -v rime_deployer || true)

if [ -z "$DEPLOYER" ]; then
    echo "🔴 Dependencies 'rime_deployer' not found." >&2
    exit 1
fi

SHARED_DATA_DIR=/usr/share/rime-data

if [ ! -d "$SHARED_DATA_DIR" ]; then
    echo "🔴 Rime shared data directory $SHARED_DATA_DIR not found." >&2
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
        output=$(GLOG_logtostderr=1 "$DEPLOYER" --build "$image_dir" "$SHARED_DATA_DIR" "$output_dir" 2>&1)
        exit_code=$?
        set -e

        if echo "$output" | grep -qE "^E[0-9]" || [ $exit_code -ne 0 ]; then
            echo "FAIL"

            if [ -n "$output" ]; then
                if echo "$output" | grep -q "^E"; then
                    echo "$output" | grep "^E" | sed 's/^/   /' >&2
                else
                    echo "$output" | sed 's/^/   /' >&2
                fi
            fi

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
