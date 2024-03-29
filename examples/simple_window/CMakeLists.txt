cmake_minimum_required(VERSION 3.25.0)
project(simple_window C)

set(CMAKE_C_STANDARD 11)

# Include seika framework as a dependency
include(FetchContent)
FetchContent_Declare(
        seika_content
        GIT_REPOSITORY https://github.com/Chukobyte/seika.git
        GIT_TAG dev
)
FetchContent_MakeAvailable(seika_content)

add_executable(${PROJECT_NAME} src/main.c)
target_link_libraries(${PROJECT_NAME} seika)
