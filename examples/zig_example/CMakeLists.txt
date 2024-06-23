cmake_minimum_required(VERSION 3.25.0)
project(zig_example C)

set(CMAKE_C_STANDARD 11)

find_program(ZIG_EXECUTABLE NAMES zig)

if (ZIG_EXECUTABLE)
    if(CMAKE_BUILD_TYPE STREQUAL "Release")
        set(ZIG_OPTIMIZE_FLAG "ReleaseSafe")
    else()
        set(ZIG_OPTIMIZE_FLAG "Debug")
    endif()

    set(EXECUTABLE_OUTPUT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/zig-out/bin/${PROJECT_NAME}.exe)

    add_custom_command(
            OUTPUT ${EXECUTABLE_OUTPUT_PATH}
            COMMAND zig build run -Dtarget=x86_64-windows-gnu -Doptimize=${ZIG_OPTIMIZE_FLAG}
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            COMMENT "Building and run zig executable"
    )

    add_custom_target(
            ${PROJECT_NAME} ALL
            DEPENDS ${EXECUTABLE_OUTPUT_PATH}
    )
else ()
    message(STATUS "Zig is either not installed or not added to path, skipping building zig_example target.")
endif ()
