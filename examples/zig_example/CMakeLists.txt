cmake_minimum_required(VERSION 3.25.0)
project(zig_example C)

set(CMAKE_C_STANDARD 11)

find_program(ZIG_EXECUTABLE NAMES zig)

if (ZIG_EXECUTABLE)
    set(SEIKA_FETCH_CONTENT_ROOT_DIR "${CMAKE_BINARY_DIR}/_deps/")
    set(SEIKA_THIRD_PARTY_DIR "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/")

    set(SEIKA_LIBS_DIRS "")
    set(SEIKA_INCLUDE_DIRS "")

    if(CMAKE_BUILD_TYPE STREQUAL "Release")
        set(ZIG_OPTIMIZE_FLAG "ReleaseSafe")
    else()
        set(ZIG_OPTIMIZE_FLAG "Debug")
    endif()

    set(EXECUTABLE_OUTPUT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/zig-out/bin/${PROJECT_NAME}.exe)

    add_custom_command(
            OUTPUT ${EXECUTABLE_OUTPUT_PATH}
            COMMAND zig build -Dtarget=x86_64-windows-gnu -Doptimize=${ZIG_OPTIMIZE_FLAG} -DlibDirs=${SEIKA_LIBS_DIRS} -DincludeDirs=${SEIKA_INCLUDE_DIRS} -DfetchContentDir=${SEIKA_FETCH_CONTENT_ROOT_DIR} -DthirdpartyDir=${SEIKA_THIRD_PARTY_DIR} --search-prefix ${seika_content_SOURCE_DIR}
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            COMMENT "Building zig executable"
    )

    add_custom_target(
            ${PROJECT_NAME} ALL
            DEPENDS ${EXECUTABLE_OUTPUT_PATH}
    )
    add_dependencies(${PROJECT_NAME} simple_window)
else ()
    message(STATUS "Zig is either not installed or not added to path, skipping building zig_example target.")
endif ()
