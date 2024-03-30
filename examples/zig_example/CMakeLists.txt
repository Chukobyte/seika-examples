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
            GIT_TAG dev
    )
    FetchContent_MakeAvailable(seika_content)

    set(SEIKA_LIBS_DIRS "${seika_content_BINARY_DIR}+C:/Users/Chukobyte/ProjectWorkspace/c_lang/seika-examples/cmake-build-release-mingw/_deps/sdl_content-build+C:/Users/Chukobyte/ProjectWorkspace/c_lang/seika-examples/cmake-build-release-mingw/_deps/freetype_content-build+C:/Users/Chukobyte/ProjectWorkspace/c_lang/seika-examples/cmake-build-release-mingw/_deps/kuba_zip_content-build+C:/Users/Chukobyte/ProjectWorkspace/c_lang/seika-examples/cmake-build-release-mingw/_deps/cglm_content-build")

    add_custom_target(
            ${PROJECT_NAME} ALL
            COMMAND zig build -DlibDirs=${SEIKA_LIBS_DIRS} -DincludeDirs=${seika_content_SOURCE_DIR} -Dtarget=x86-windows-gnu --search-prefix ${seika_content_SOURCE_DIR}
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            COMMENT "Building zig executable"
    )
else ()
    message(STATUS "Zig is either not installed or not added to path, skipping building zig_example target.")
endif ()
