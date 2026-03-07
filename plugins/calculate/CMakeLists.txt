cmake_minimum_required(VERSION 3.10.2)
project("calculate")

set(CMAKE_C_STANDARD 11)

add_library(calculate SHARED
    native_lib.c
)
