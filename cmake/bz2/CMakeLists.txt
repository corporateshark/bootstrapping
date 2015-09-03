cmake_minimum_required(VERSION 2.8)
project(bz2)

include(../../msvc.cmake)

set(SRCDIR ${CMAKE_CURRENT_SOURCE_DIR}/../../src)
set(LIBDIR ${SRCDIR}/bzip2)

add_library(bz2
        ${LIBDIR}/blocksort.c
        ${LIBDIR}/bzlib.c
        ${LIBDIR}/compress.c
        ${LIBDIR}/crctable.c
        ${LIBDIR}/decompress.c
        ${LIBDIR}/huffman.c
        ${LIBDIR}/randtable.c
)
target_include_directories(bz2 PUBLIC ${LIBDIR})
