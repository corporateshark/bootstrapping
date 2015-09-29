cmake_minimum_required(VERSION 2.8)

project(zopfli)

include(../../msvc.cmake)

set(SRCDIR ${CMAKE_CURRENT_SOURCE_DIR}/../../src)
set(LIBDIR ${SRCDIR}/zopfli)

add_library(zopfli STATIC
    ${LIBDIR}/src/zopfli/blocksplitter.c
    ${LIBDIR}/src/zopfli/cache.c
    ${LIBDIR}/src/zopfli/deflate.c
    ${LIBDIR}/src/zopfli/gzip_container.c
    ${LIBDIR}/src/zopfli/hash.c
    ${LIBDIR}/src/zopfli/katajainen.c
    ${LIBDIR}/src/zopfli/lz77.c
    ${LIBDIR}/src/zopfli/squeeze.c
    ${LIBDIR}/src/zopfli/tree.c
    ${LIBDIR}/src/zopfli/util.c
    ${LIBDIR}/src/zopfli/zlib_container.c
    ${LIBDIR}/src/zopfli/zopfli_lib.c
)

target_include_directories(zopfli
    PUBLIC
    ${LIBDIR}/src
)