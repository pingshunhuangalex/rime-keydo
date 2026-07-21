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

readonly ENUM_OS_MAC="mac"
readonly ENUM_OS_WIN="win"
readonly ENUM_OS_UNKNOWN="unknown"
OS_TYPE=""

case "$(uname -s)" in
    Darwin*)
        OS_TYPE="${ENUM_OS_MAC}"
        ;;
    CYGWIN*|MINGW32*|MSYS*|MINGW*)
        OS_TYPE="${ENUM_OS_WIN}"
        ;;
    *)
        OS_TYPE="${ENUM_OS_UNKNOWN}"
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
    local target_os=$1
    local target_image=$2
    local platform

    case "$target_os" in
        "${ENUM_OS_MAC}")
            platform=" for Mac"
            ;;
        "${ENUM_OS_WIN}")
            platform=" for Windows"
            ;;
        *)
            platform=""
            ;;
    esac

    echo "🟣 Building Keydo${platform}..."
    local target_path="${BUILD_DIR}/${target_image}"
    mkdir -p "${target_path}"

    for folder in rime schema dicts; do
        if [[ -d "$folder" ]]; then
            find "$folder" -maxdepth 1 -type f -exec cp -a {} "${target_path}/" \; 2>/dev/null || true

            if [[ -d "$folder/$target_os" ]]; then
                find "$folder/$target_os" -mindepth 1 -maxdepth 1 -exec cp -a {} "${target_path}/" \; 2>/dev/null || true
            fi
        fi
    done

    if [[ -d "logic" ]]; then
        mkdir -p "${target_path}/lua"

        find logic -maxdepth 1 -type f ! -name "*.draft.*" -exec cp -a {} "${target_path}/" \; 2>/dev/null || true
        find logic -mindepth 1 -maxdepth 1 -type d -exec cp -a {} "${target_path}/lua/" \; 2>/dev/null || true
        find "${target_path}/lua" -type f -name "*.draft.*" -delete 2>/dev/null || true
    fi

    # Display directory structure for the built image
    if command -v eza &> /dev/null; then
        eza --tree "${target_path}"
    elif command -v tree &> /dev/null; then
        tree "${target_path}"
    else
        find "${target_path}" -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
    fi

    if [[ "$IS_RELEASE" -eq 1 ]]; then
        echo "🟣 Compressing Keydo release image${platform}..."
        (cd "${target_path}" && zip -qr "../${target_image}.zip" *)
    fi
}

HAS_MAC_IMAGE=0
HAS_WIN_IMAGE=0
IMAGE_EXT=""

if [[ "$IS_RELEASE" -eq 1 ]]; then
    HAS_MAC_IMAGE=1
    HAS_WIN_IMAGE=1
else
    if [[ "$OS_TYPE" == "${ENUM_OS_MAC}" || "$OS_TYPE" == "${ENUM_OS_UNKNOWN}" ]]; then
        HAS_MAC_IMAGE=1
    fi
    if [[ "$OS_TYPE" == "${ENUM_OS_WIN}" || "$OS_TYPE" == "${ENUM_OS_UNKNOWN}" ]]; then
        HAS_WIN_IMAGE=1
    fi
fi

if [[ "$HAS_MAC_IMAGE" -eq 1 ]]; then
    build_image "${ENUM_OS_MAC}" "${MAC_IMAGE}"
fi

if [[ "$HAS_WIN_IMAGE" -eq 1 ]]; then
    build_image "${ENUM_OS_WIN}" "${WIN_IMAGE}"
fi

if [[ "$IS_RELEASE" -eq 1 ]]; then
    IMAGE_EXT=".zip"
else
    IMAGE_EXT="/"
fi

echo "🟢 Keydo images built and are ready for Rime deployment!"
echo "+----------+------------------------------------------+"
printf "| %-8s | %-40s |\n" "Platform" "Image"
echo "+----------+------------------------------------------+"

if [[ "$HAS_MAC_IMAGE" -eq 1 ]]; then
    printf "| %-8s | %-40s |\n" "Mac" "${BUILD_DIR}/${MAC_IMAGE}${IMAGE_EXT}"
fi

if [[ "$HAS_WIN_IMAGE" -eq 1 ]]; then
    printf "| %-8s | %-40s |\n" "Win" "${BUILD_DIR}/${WIN_IMAGE}${IMAGE_EXT}"
fi

echo "+----------+------------------------------------------+"
