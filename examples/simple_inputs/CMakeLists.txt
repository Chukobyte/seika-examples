cmake_minimum_required(VERSION 3.25.0)
project(simple_inputs C)

set(CMAKE_C_STANDARD 11)

add_executable(${PROJECT_NAME} src/main.c)
target_link_libraries(${PROJECT_NAME} seika)
