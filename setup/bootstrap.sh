#!/usr/bin/env bash
set -euo pipefail
cd ..
ROOT_DIR="$(pwd)"
rm -rf "$ROOT_DIR/setup/bootstrap.log"
LOG_FILE="$ROOT_DIR/setup/bootstrap.log"
exec > >(tee -a "$LOG_FILE") 2>&1
DEPS_DIR="$ROOT_DIR/deps"
VENDOR_DIR="$ROOT_DIR/vendor"

SDL_PREFIX="$DEPS_DIR/sdl"
VULKAN_PREFIX="$DEPS_DIR/vulkan"

mkdir -p "$DEPS_DIR"
mkdir -p "$VENDOR_DIR"

echo "======================================"
echo " Project-local SDK bootstrap starting "
echo "======================================"

# --------------------------------------
# System deps (still required)
# --------------------------------------
echo "== Installing system dependencies =="
sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get install -y \
  cmake build-essential git make pkg-config ninja-build \
  mingw-w64 mingw-w64-tools \
  gnome-desktop-testing \
  libasound2-dev libpulse-dev libaudio-dev \
  libfribidi-dev libjack-dev libsndio-dev \
  libx11-dev libxext-dev libxrandr-dev libxcursor-dev \
  libxfixes-dev libxi-dev libxss-dev libxtst-dev \
  libxkbcommon-dev libdrm-dev libgbm-dev \
  libgl1-mesa-dev libgles2-mesa-dev libegl1-mesa-dev \
  libdbus-1-dev libibus-1.0-dev libudev-dev libthai-dev \
  libunwind-dev libusb-1.0-0-dev libavcodec-dev \
  libavformat-dev libavutil-dev libswscale-dev

# --------------------------------------
# SDL
# --------------------------------------
cd "$VENDOR_DIR"

if [ ! -d SDL ]; then
  git clone https://github.com/libsdl-org/SDL.git
fi

cd SDL

echo "== Building SDL (native -> $SDL_PREFIX) =="
cmake -S . -B build \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$SDL_PREFIX"

cmake --build build -j
cmake --install build

echo "== Building SDL (Windows cross) =="
cmake -S . -B build-win \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_TOOLCHAIN_FILE=../../toolchains/toolchain-windows.cmake \
  -DCMAKE_INSTALL_PREFIX="$SDL_PREFIX/win"

cmake --build build-win -j
cmake --install build-win

cd "$VENDOR_DIR"

# --------------------------------------
# Vulkan Loader
# --------------------------------------
if [ ! -d Vulkan-Loader ]; then
  git clone https://github.com/KhronosGroup/Vulkan-Loader
fi

cd Vulkan-Loader

echo "== Building Vulkan Loader (native -> $VULKAN_PREFIX) =="
cmake -S . -B build \
  -DCMAKE_BUILD_TYPE=Release \
  -DUPDATE_DEPS=ON \
  -DCMAKE_INSTALL_PREFIX="$VULKAN_PREFIX"

cmake --build build -j
cmake --install build

echo "== Vulkan Loader (Windows cross) =="
cmake -S . -B build-win \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_TOOLCHAIN_FILE=../../toolchains/toolchain-windows.cmake \
  -DUPDATE_DEPS=ON \
  -DCMAKE_INSTALL_PREFIX="$VULKAN_PREFIX/win" \
  -DVULKAN_ENABLE_ASM=OFF

cmake --build build-win -j
cmake --install build-win

cd "$VENDOR_DIR"

# --------------------------------------
# Vulkan Headers
# --------------------------------------
if [ ! -d Vulkan-Headers ]; then
  git clone https://github.com/KhronosGroup/Vulkan-Headers
fi

cd Vulkan-Headers

echo "== Building Vulkan Headers (native -> $VULKAN_PREFIX) =="
cmake -S . -B build \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$VULKAN_PREFIX"

cmake --install build

echo "== Building Vulkan Headers (Windows cross) =="
cmake -S . -B build-win \
  -DCMAKE_BUILD_TYPE=Release \
  -DVULKAN_ENABLE_ASM=OFF \
  -DCMAKE_TOOLCHAIN_FILE=../../toolchains/toolchain-windows.cmake \
  -DCMAKE_INSTALL_PREFIX="$VULKAN_PREFIX/win"

cmake --install build-win

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get autoremove -y

cd "$ROOT_DIR"

echo "======================================"
echo " Bootstrap complete "
echo "======================================"
echo ""
echo "Add this to your project CMake invocation:"
echo ""
echo "  -DCMAKE_PREFIX_PATH=$DEPS_DIR/sdl;$DEPS_DIR/vulkan"
echo ""
echo "Or in CMakeLists.txt:"
echo "  list(APPEND CMAKE_PREFIX_PATH \"\${CMAKE_SOURCE_DIR}/deps/sdl\")"
echo "  list(APPEND CMAKE_PREFIX_PATH \"\${CMAKE_SOURCE_DIR}/deps/vulkan\")"