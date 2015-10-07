cmake_minimum_required(VERSION 2.8)
project(id3v2lib)

include(../../msvc.cmake)

set(SRCDIR ${CMAKE_CURRENT_SOURCE_DIR}/../../src)
set(LIBDIR ${SRCDIR}/id3v2lib)

add_definitions(
        -DLIBDIR
)

add_library(id3v2lib
        ${LIBDIR}/src/frame.c
        ${LIBDIR}/src/header.c
        ${LIBDIR}/src/id3v2lib.c
        ${LIBDIR}/src/types.c
        ${LIBDIR}/src/utils.c
)
target_include_directories(id3v2lib PUBLIC
        ${LIBDIR}
        ${LIBDIR}/include
        ${LIBDIR}/include/id3v2lib
)
if(NOT MSVC)
    set_target_properties(id3v2lib PROPERTIES COMPILE_FLAGS "-Wno-int-conversion -Wno-tautological-compare -Wno-parentheses-equality -Wno-static-in-inline")
endif()
