cmake_minimum_required(VERSION 3.25.0)
project(test C)

set(CMAKE_C_STANDARD 11)

# Include seika framework as a dependency
include(FetchContent)

FetchContent_Declare(
        seika
        GIT_REPOSITORY https://github.com/Chukobyte/seika.git
        GIT_TAG main
)

FetchContent_MakeAvailable(seika)

add_executable(${PROJECT_NAME}_app src/main.c)
target_link_libraries(${PROJECT_NAME}_app seika)
target_include_directories(${PROJECT_NAME}_app PRIVATE
        $<TARGET_PROPERTY:seika,INTERFACE_INCLUDE_DIRECTORIES>
)
