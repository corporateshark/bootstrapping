cmake_minimum_required(VERSION 2.8)
project(z)

include(../../msvc.cmake)

set(SRCDIR ${CMAKE_CURRENT_SOURCE_DIR}/../../src)
set(LIBDIR ${SRCDIR}/zlib)

add_library(z
        ${LIBDIR}/adler32.c
        ${LIBDIR}/compress.c
        ${LIBDIR}/crc32.c
        ${LIBDIR}/deflate.c
        ${LIBDIR}/gzclose.c
        ${LIBDIR}/gzlib.c
        ${LIBDIR}/gzread.c
        ${LIBDIR}/gzwrite.c
        ${LIBDIR}/infback.c
        ${LIBDIR}/inffast.c
        ${LIBDIR}/inflate.c
        ${LIBDIR}/inftrees.c
        ${LIBDIR}/trees.c
        ${LIBDIR}/uncompr.c
        ${LIBDIR}/zutil.c
)
target_include_directories(z PUBLIC ${LIBDIR})

if(NOT MSVC)
        set_target_properties(z PROPERTIES COMPILE_FLAGS "-Wno-implicit-function-declaration")
endif()