cmake_minimum_required(VERSION 3.16)
project(RollbackEngine)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(PROJECT_DEPS_ROOT "${CMAKE_CURRENT_LIST_DIR}/deps")

list(APPEND CMAKE_PREFIX_PATH
    "${PROJECT_DEPS_ROOT}/sdl"
    "${PROJECT_DEPS_ROOT}/vulkan"
)

set(IMGUI_DIR ${PROJECT_DEPS_ROOT}/imgui/include)

set(IMGUI_SRC
    ${IMGUI_DIR}/imgui.cpp
    ${IMGUI_DIR}/imgui_demo.cpp
    ${IMGUI_DIR}/imgui_draw.cpp
    ${IMGUI_DIR}/imgui_tables.cpp
    ${IMGUI_DIR}/imgui_widgets.cpp

    ${IMGUI_DIR}/backends/imgui_impl_sdl3.cpp
    ${IMGUI_DIR}/backends/imgui_impl_vulkan.cpp
)

add_executable(RollbackEngine 
    main.cpp
    ${IMGUI_SRC}
)

target_include_directories(RollbackEngine PRIVATE
    ${IMGUI_DIR}
    ${IMGUI_DIR}/backends
)

find_package(SDL3 REQUIRED)
find_package(VulkanLoader REQUIRED)
find_package(VulkanHeaders REQUIRED CONFIG)

target_link_libraries(RollbackEngine PRIVATE
    SDL3::SDL3
    Vulkan::Headers
    Vulkan::Loader
)

set(CMAKE_EXE_LINKER_FLAGS_INIT "-fuse-ld=lld")
set(CMAKE_SHARED_LINKER_FLAGS_INIT "-fuse-ld=lld")

find_program(CCACHE_PROGRAM ccache)
if(CCACHE_PROGRAM)
    set(CMAKE_C_COMPILER_LAUNCHER ${CCACHE_PROGRAM})
    set(CMAKE_CXX_COMPILER_LAUNCHER ${CCACHE_PROGRAM})
endif()

if (CMAKE_SYSTEM_NAME STREQUAL "Windows")
    add_custom_command(TARGET RollbackEngine POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${PROJECT_DEPS_ROOT}/sdl/win/bin/SDL3.dll"
            $<TARGET_FILE_DIR:RollbackEngine>
    )
endif()