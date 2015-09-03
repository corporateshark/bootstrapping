cmake_minimum_required(VERSION 2.8)
project(iconv)

include(../../msvc.cmake)

set(SRCDIR ${CMAKE_CURRENT_SOURCE_DIR}/../../src)
set(LIBDIR ${SRCDIR}/libiconv)

add_definitions(
        -DLIBDIR
)

add_library(iconv
        ${LIBDIR}/lib/iconv.c
        ${LIBDIR}/lib/relocatable.c
        ${LIBDIR}/libcharset/lib/localcharset.c
)
target_include_directories(iconv PUBLIC
        ${LIBDIR}
        ${LIBDIR}/include
        ${LIBDIR}/lib
        ${LIBDIR}/srclib
)
if(NOT MSVC)
    set_target_properties(iconv PROPERTIES COMPILE_FLAGS "-Wno-int-conversion -Wno-tautological-compare -Wno-parentheses-equality -Wno-static-in-inline")
endif()
