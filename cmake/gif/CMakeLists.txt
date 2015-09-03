cmake_minimum_required(VERSION 2.8)
project(gif)

include(../../msvc.cmake)

set(SRCDIR ${CMAKE_CURRENT_SOURCE_DIR}/../../src)
set(LIBDIR ${SRCDIR}/giflib)

add_library(gif
        ${LIBDIR}/lib/dgif_lib.c
        ${LIBDIR}/lib/gif_err.c
        ${LIBDIR}/lib/gif_font.c
        ${LIBDIR}/lib/gif_hash.c
        ${LIBDIR}/lib/gifalloc.c
)
target_include_directories(gif PUBLIC ${LIBDIR}/lib)
