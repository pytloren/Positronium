cmake_minimum_required(VERSION 3.21)

project(Positronium LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(WIN32 AND NOT CMAKE_SIZEOF_VOID_P EQUAL 8)
  message(FATAL_ERROR "Positronium requires a 64-bit build on Windows.")
endif()

find_package(ROOT CONFIG REQUIRED COMPONENTS Gui)
include(${ROOT_USE_FILE})

add_executable(Positronium positronium.cpp)
target_link_libraries(Positronium PRIVATE ${ROOT_LIBRARIES})

# Keep symbols for VS Code's Windows debugger while linking against the
# Release-only CERN ROOT libraries shipped with this environment.
if(MSVC)
  target_compile_options(Positronium PRIVATE /Zi)
  target_link_options(Positronium PRIVATE /DEBUG)
endif()
