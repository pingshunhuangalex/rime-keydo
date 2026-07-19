#!/bin/bash
set -euo pipefail

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "${REPO_ROOT}"

IS_RELEASE=0
TAG_NAME=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --release)
            IS_RELEASE=1
            shift
            ;;
        --tag)
            # Ensure the next argument exists and isn't another flag
            if [[ -n "${2:-}" && "$2" != -* ]]; then
                TAG_NAME="$2"
                shift 2
            else
                echo "🔴 Tag name for --tag flag not found." >&2
                exit 1
            fi
            ;;
        *)
            echo "🔴 Argument $1 not found." >&2
            exit 1
            ;;
    esac
done

if [[ -n "${TAG_NAME}" ]]; then
    MAC_IMAGE="keydo-mac-${TAG_NAME}.zip"
    WIN_IMAGE="keydo-win-${TAG_NAME}.zip"
else
    MAC_IMAGE="keydo-mac.zip"
    WIN_IMAGE="keydo-win.zip"
fi

echo "🟣 Building Keydo for Mac..."
cp platform/mac/keydo.custom.yaml ./keydo.custom.yaml
zip -qr "${MAC_IMAGE}" \
    lua/ \
    rime.lua \
    default.custom.yaml \
    squirrel.custom.yaml \
    keydo.*.yaml \
    -x "lua/*.draft.lua"
rm ./keydo.custom.yaml

echo "🟣 Building Keydo for Windows..."
cp platform/win/keydo.custom.yaml ./keydo.custom.yaml
zip -qr "${WIN_IMAGE}" \
    lua/ \
    rime.lua \
    default.custom.yaml \
    weasel.custom.yaml \
    keydo.*.yaml \
    -x "lua/*.draft.lua"
rm ./keydo.custom.yaml

if [[ "$IS_RELEASE" -eq 1 ]]; then
    echo "🟢 Keydo artifacts built and compressed!"
    echo "+----------+------------------------------------------+"
    printf "| %-8s | %-40s |\n" "Platform" "Artifact"
    echo "+----------+------------------------------------------+"
    printf "| %-8s | %-40s |\n" "Mac" "${MAC_IMAGE}"
    printf "| %-8s | %-40s |\n" "Windows" "${WIN_IMAGE}"
    echo "+----------+------------------------------------------+"
else
    echo "🟢 Keydo images built!"
fi
