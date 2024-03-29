cmake_minimum_required(VERSION 3.25.0)
project(zig_example C)

set(CMAKE_C_STANDARD 11)

find_program(ZIG_EXECUTABLE NAMES zig)

if (ZIG_EXECUTABLE)
    # Include seika framework as a dependency
    include(FetchContent)
    FetchContent_Declare(
            seika_content
            GIT_REPOSITORY https://github.com/Chukobyte/seika.git
            GIT_TAG v0.1.0
    )
    FetchContent_MakeAvailable(seika_content)

    add_custom_target(
            ${PROJECT_NAME} ALL
            COMMAND zig build --search-prefix ${seika_content_SOURCE_DIR}
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            COMMENT "Building zig executable"
    )
else ()
    message(STATUS "Zig is either not installed or added to path, skipping building zig_example target.")
endif ()
