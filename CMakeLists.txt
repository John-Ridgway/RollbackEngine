cmake_minimum_required(VERSION 3.16)
project(RollbackEngine)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(PROJECT_DEPS_ROOT "${CMAKE_CURRENT_LIST_DIR}/deps")

list(APPEND CMAKE_PREFIX_PATH
    "${PROJECT_DEPS_ROOT}/sdl"
    "${PROJECT_DEPS_ROOT}/vulkan"
)

add_executable(RollbackEngine main.cpp)

find_package(SDL3 REQUIRED)
find_package(VulkanLoader REQUIRED)
find_package(VulkanHeaders REQUIRED CONFIG)

target_link_libraries(RollbackEngine PRIVATE
    SDL3::SDL3
    Vulkan::Headers
    Vulkan::Loader
)