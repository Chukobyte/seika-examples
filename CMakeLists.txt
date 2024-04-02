cmake_minimum_required(VERSION 3.25.0)
project(seika_examples C)

include(FetchContent)

# Using shared libs to make compatible with zig build
set(SEIKA_STATIC_LIB OFF)
FetchContent_Declare(
        seika_content
        GIT_REPOSITORY https://github.com/Chukobyte/seika.git
        GIT_TAG v0.1.2
)
FetchContent_MakeAvailable(seika_content)

add_subdirectory(examples/simple_window)
add_subdirectory(examples/simple_inputs)
add_subdirectory(examples/zig_example)
