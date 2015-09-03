cmake_minimum_required(VERSION 2.8)
project(png)

include(../../msvc.cmake)

set(SRCDIR ${CMAKE_CURRENT_SOURCE_DIR}/../../src)
set(LIBDIR ${SRCDIR}/libpng)

add_library(png
        ${LIBDIR}/png.c
        ${LIBDIR}/pngerror.c
        ${LIBDIR}/pngget.c
        ${LIBDIR}/pngmem.c
        ${LIBDIR}/pngpread.c
        ${LIBDIR}/pngread.c
        ${LIBDIR}/pngrio.c
        ${LIBDIR}/pngrtran.c
        ${LIBDIR}/pngrutil.c
        ${LIBDIR}/pngset.c
        ${LIBDIR}/pngtrans.c
        ${LIBDIR}/pngwio.c
        ${LIBDIR}/pngwrite.c
        ${LIBDIR}/pngwtran.c
        ${LIBDIR}/pngwutil.c
        ${LIBDIR}/arm/arm_init.c
        ${LIBDIR}/arm/filter_neon_intrinsics.c
)
target_include_directories(png PUBLIC ${SRCDIR}/zlib ${LIBDIR})
