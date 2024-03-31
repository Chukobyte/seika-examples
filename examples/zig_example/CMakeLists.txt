cmake_minimum_required(VERSION 3.25.0)
project(zig_example C)

set(CMAKE_C_STANDARD 11)

find_program(ZIG_EXECUTABLE NAMES zig)

if (ZIG_EXECUTABLE)
    set(THREADS_PREFER_PTHREAD_FLAG ON)
    find_package(Threads REQUIRED)
    message(STATUS "CMAKE_THREAD_LIBS_INIT: ${CMAKE_THREAD_LIBS_INIT}")
    message(STATUS "CMAKE_USE_WIN32_THREADS_INIT: ${CMAKE_USE_WIN32_THREADS_INIT}")
    message(STATUS "Threads_FOUND: ${Threads_FOUND}")

    # Include seika framework as a dependency
    include(FetchContent)
    FetchContent_Declare(
            seika_content
            GIT_REPOSITORY https://github.com/Chukobyte/seika.git
            GIT_TAG v0.1.1
    )
    FetchContent_MakeAvailable(seika_content)
    set_target_properties(seika PROPERTIES
            C_STANDARD 11
            C_STANDARD_REQUIRED YES
    )

    set(SEIKA_FETCH_CONTENT_ROOT_DIR "${CMAKE_BINARY_DIR}/_deps/")
    set(SEIKA_THIRD_PARTY_DIR "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/")

    set(SEIKA_LIBS_DIRS "")
    set(SEIKA_INCLUDE_DIRS "")

    add_custom_target(
            ${PROJECT_NAME} ALL
            COMMAND zig build -DlibDirs=${SEIKA_LIBS_DIRS} -DincludeDirs=${SEIKA_INCLUDE_DIRS} -DfetchContentDir=${SEIKA_FETCH_CONTENT_ROOT_DIR} -DthirdpartyDir=${SEIKA_THIRD_PARTY_DIR} -Dtarget=x86_64-windows-gnu --search-prefix ${seika_content_SOURCE_DIR}
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            COMMENT "Building zig executable"
    )
    add_dependencies(${PROJECT_NAME} simple_window)
else ()
    message(STATUS "Zig is either not installed or not added to path, skipping building zig_example target.")
endif ()
