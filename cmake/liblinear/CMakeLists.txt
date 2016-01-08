cmake_minimum_required(VERSION 2.8)
project(liblinear)

include(../../msvc.cmake)

set(SRCDIR ${CMAKE_CURRENT_SOURCE_DIR}/../../src)
set(LIBDIR ${SRCDIR}/liblinear)

add_library(liblinear
		${LIBDIR}/linear.cpp
		${LIBDIR}/tron.cpp
		${LIBDIR}/blas/blas.h
		${LIBDIR}/blas/blasp.h
		${LIBDIR}/blas/daxpy.c
		${LIBDIR}/blas/ddot.c
		${LIBDIR}/blas/dnrm2.c
		${LIBDIR}/blas/dscal.c
		${LIBDIR}/tron.h
		${LIBDIR}/linear.h
)

target_include_directories(liblinear PUBLIC ${LIBDIR})
