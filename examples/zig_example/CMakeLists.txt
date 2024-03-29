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

#    # Get include directories
#    get_target_property(SEIKA_INCLUDE_DIRS seika INTERFACE_INCLUDE_DIRECTORIES)
#    # Get library directories (if seika is a target with libraries)
#    get_target_property(SEIKA_LIBRARY_DIRS seika INTERFACE_LINK_DIRECTORIES)
#
#    # Convert the list to a string with spaces
#    string(REPLACE ";" " " SEIKA_INCLUDE_DIRS_STR "${SEIKA_INCLUDE_DIRS}")
#    string(REPLACE ";" " " SEIKA_LIBRARY_DIRS_STR "${SEIKA_LIBRARY_DIRS}")
#
#    # Output the results
#    message("Include directories: ${SEIKA_INCLUDE_DIRS_STR}")
#    message("Library directories: ${SEIKA_LIBRARY_DIRS_STR}")

    #            COMMAND "zig build -DlibDirs=${SEIKA_LIBRARY_DIRS} -DincludeDirs=${SEIKA_INCLUDE_DIRS} --search-prefix ${seika_content_SOURCE_DIR}"

    add_custom_target(
            ${PROJECT_NAME} ALL
            COMMAND zig build -DlibDirs=${seika_content_BINARY_DIR} -DincludeDirs=${seika_content_SOURCE_DIR} --search-prefix ${seika_content_SOURCE_DIR}
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            COMMENT "Building zig executable"
    )
else ()
    message(STATUS "Zig is either not installed or added to path, skipping building zig_example target.")
endif ()
