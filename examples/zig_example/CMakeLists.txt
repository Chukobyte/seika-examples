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
            GIT_TAG dev
    )
    FetchContent_MakeAvailable(seika_content)
    set_target_properties(seika PROPERTIES
            C_STANDARD 11
            C_STANDARD_REQUIRED YES
    )

    set(SEIKA_LIBS_DIRS "${seika_content_BINARY_DIR}+C:/Users/Chukobyte/ProjectWorkspace/c_lang/seika-examples/cmake-build-release-mingw/_deps/sdl_content-build+C:/Users/Chukobyte/ProjectWorkspace/c_lang/seika-examples/cmake-build-release-mingw/_deps/freetype_content-build+C:/Users/Chukobyte/ProjectWorkspace/c_lang/seika-examples/cmake-build-release-mingw/_deps/kuba_zip_content-build+C:/Users/Chukobyte/ProjectWorkspace/c_lang/seika-examples/cmake-build-release-mingw/_deps/cglm_content-build+C:/Program Files/JetBrains/CLion 2023.2.2/bin/mingw/lib/gcc/x86_64-w64-mingw32/13.1.0+C:/Users/Chukobyte/ProjectWorkspace/c_lang/seika-examples/temp/pthreads-win32/lib/x64")
    set(SEIKA_INCLUDE_DIRS "${seika_content_SOURCE_DIR}+C:/Users/Chukobyte/ProjectWorkspace/c_lang/seika-examples/cmake-build-release-mingw/_deps/sdl_content-src/include+C:/Users/Chukobyte/ProjectWorkspace/c_lang/seika-examples/temp/pthreads-win32/include")

    add_custom_target(
            ${PROJECT_NAME} ALL
            COMMAND zig build -DlibDirs=${SEIKA_LIBS_DIRS} -DincludeDirs=${SEIKA_INCLUDE_DIRS} -Dtarget=x86_64-windows-gnu --search-prefix ${seika_content_SOURCE_DIR}
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            COMMENT "Building zig executable"
    )
else ()
    message(STATUS "Zig is either not installed or not added to path, skipping building zig_example target.")
endif ()
