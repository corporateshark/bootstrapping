cmake_minimum_required(VERSION 2.8)
project(FAST)

include(../../msvc.cmake)

set(SRCDIR ${CMAKE_CURRENT_SOURCE_DIR}/../../src)
set(LIBDIR ${SRCDIR}/FAST)

add_library(FAST
        ${LIBDIR}/fast_9_MH.cpp
        ${LIBDIR}/nonmax_MH.cpp
)
target_include_directories(FAST PUBLIC ${SRCDIR})