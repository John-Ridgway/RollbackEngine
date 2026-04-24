# **Rollback Engine**
A "Linux-First" Game Engine
- Includes modern features like SDL3 and Vulkan
- Ability to Cross-Compile for Windows by default
    - Maybe other platforms in the future
- Aims to bring convenience to Game Development for Linux without sacrificing access to other platforms

## *Quick Start Guide*
#### __Linux__

First, pull the Repository:

```
git pull https://github.com/John-Ridgway/RollbackEngine.git
```

Navigate to the setup directory:

```
cd RollbackEngine/setup
```

Run the Bootstrapper*:

```
./run-bootstrap.sh
```

_*you will need root privilege for this_

---
VS Code tasks have been included with this repository. To compile in VS Code for both Linux and Windows, follow these steps:
>CTRL+SHIFT+P -> Run Task -> Build All

If you aren't using VS Code, in your terminal from the Project root (e.g. /RollbackEngine) run the following commands:

_Linux_
```
cmake -S . -B build
cmake --build build -j
```
_Windows_
```
cmake -S . -B build-win -DCMAKE_TOOLCHAIN_FILE=./toolchains/toolchain-windows.cmake
cmake --build build-win -j
cp ./deps/sdl/win/bin/SDL3.dll ./build-win
```
_*For windows we need to copy the SDL3 dll_

## Summary

Nothing fancy for now. A simple window initialization for testing that the libraries are compiling correctly.

