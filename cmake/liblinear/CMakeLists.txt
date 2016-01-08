cmake_minimum_required(VERSION 2.8)
project(liblinear)

include(../../msvc.cmake)

set(SRCDIR ${CMAKE_CURRENT_SOURCE_DIR}/../../src)
set(LIBDIR ${SRCDIR}/liblinear)

add_library(liblinear
		${LIBDIR}/src/liblinear/linear.cpp
		${LIBDIR}/src/liblinear/tron.cpp
		${LIBDIR}/src/liblinear/blas/blas.h
		${LIBDIR}/src/liblinear/blas/blasp.h
		${LIBDIR}/src/liblinear/blas/daxpy.c
		${LIBDIR}/src/liblinear/blas/ddot.c
		${LIBDIR}/src/liblinear/blas/dnrm2.c
		${LIBDIR}/src/liblinear/blas/dscal.c
		${LIBDIR}/src/liblinear/tron.h
		${LIBDIR}/src/liblinear/linear.h)
)
target_include_directories(liblinear PUBLIC ${LIBDIR})
