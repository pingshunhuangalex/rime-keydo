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

OS_TYPE="unknown"

case "$(uname -s)" in
    Darwin*)
        OS_TYPE="mac"
        ;;
    CYGWIN*|MINGW32*|MSYS*|MINGW*)
        OS_TYPE="win"
        ;;
esac

IMAGE_SUFFIX=""

if [[ -n "${TAG_NAME}" ]]; then
    IMAGE_SUFFIX="-${TAG_NAME}"
fi

MAC_IMAGE="keydo-mac${IMAGE_SUFFIX}"
WIN_IMAGE="keydo-win${IMAGE_SUFFIX}"

echo "🟣 Cleaning previously built images..."
BUILD_DIR="build"
rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"

build_image() {
    local platform=$1
    local target_image=$2
    local schema_src=$3
    local platform_specific_yaml=$4

    echo "🟣 Building Keydo for ${platform}..."
    local target_path="${BUILD_DIR}/${target_image}"
    mkdir -p "${target_path}"

    cp -R lua/ "${target_path}/"
    find "${target_path}/lua" -name "*.draft.lua" -type f -delete
    cp rime.lua default.custom.yaml "${platform_specific_yaml}" "${target_path}/"

    for f in keydo.*.yaml; do
        [[ -e "$f" ]] && cp "$f" "${target_path}/"
    done

    cp "${schema_src}" "${target_path}/keydo.custom.yaml"

    if [[ "$IS_RELEASE" -eq 1 ]]; then
        echo "🟣 Compressing Keydo ${platform} image for releases..."
        (cd "${target_path}" && zip -qr "../${target_image}.zip" *)
    fi
}

HAS_MAC_IMAGE=0
HAS_WIN_IMAGE=0

if [[ "$IS_RELEASE" -eq 1 ]]; then
    HAS_MAC_IMAGE=1
    HAS_WIN_IMAGE=1
else
    if [[ "$OS_TYPE" == "mac" || "$OS_TYPE" == "unknown" ]]; then
        HAS_MAC_IMAGE=1
    fi
    if [[ "$OS_TYPE" == "win" || "$OS_TYPE" == "unknown" ]]; then
        HAS_WIN_IMAGE=1
    fi
fi

if [[ "$HAS_MAC_IMAGE" -eq 1 ]]; then
    build_image "Mac" "${MAC_IMAGE}" "schema/mac/keydo.custom.yaml" "squirrel.custom.yaml"
fi

if [[ "$HAS_WIN_IMAGE" -eq 1 ]]; then
    build_image "Windows" "${WIN_IMAGE}" "schema/win/keydo.custom.yaml" "weasel.custom.yaml"
fi

if [[ "$IS_RELEASE" -eq 1 ]]; then
    IMAGE_EXT=".zip"
else
    IMAGE_EXT="/"
fi

echo "🟢 Keydo images built!"
echo "+----------+------------------------------------------+"
printf "| %-8s | %-40s |\n" "Platform" "Output"
echo "+----------+------------------------------------------+"

if [[ "$HAS_MAC_IMAGE" -eq 1 ]]; then
    printf "| %-8s | %-40s |\n" "Mac" "${BUILD_DIR}/${MAC_IMAGE}${IMAGE_EXT}"
fi

if [[ "$HAS_WIN_IMAGE" -eq 1 ]]; then
    printf "| %-8s | %-40s |\n" "Win" "${BUILD_DIR}/${WIN_IMAGE}${IMAGE_EXT}"
fi

echo "+----------+------------------------------------------+"
