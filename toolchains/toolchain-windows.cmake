# =========================
# Windows MinGW Toolchain
# =========================

set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

# -------------------------
# Compilers
# -------------------------
set(CMAKE_C_COMPILER x86_64-w64-mingw32-gcc)
set(CMAKE_CXX_COMPILER x86_64-w64-mingw32-g++)

# -------------------------
# Static runtime (recommended)
# -------------------------
set(CMAKE_C_FLAGS_INIT "-static-libgcc")
set(CMAKE_CXX_FLAGS_INIT "-static-libgcc -static-libstdc++")

# -------------------------
# Project-local SDK root
# -------------------------
# This is the BIG fix: point to your deps/ folder
set(PROJECT_DEPS_ROOT "${CMAKE_CURRENT_LIST_DIR}/../deps")

# Windows-specific installs of SDL/Vulkan
set(CMAKE_FIND_ROOT_PATH
    /usr/x86_64-w64-mingw32
    "${PROJECT_DEPS_ROOT}/sdl/win"
    "${PROJECT_DEPS_ROOT}/vulkan/win"
)

# -------------------------
# Cross build search rules
# -------------------------
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# -------------------------
# Helpful prefix path
# -------------------------
list(APPEND CMAKE_PREFIX_PATH
    "${PROJECT_DEPS_ROOT}/sdl/win"
    "${PROJECT_DEPS_ROOT}/vulkan/win"
)