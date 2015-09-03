cmake_minimum_required(VERSION 2.8)
project(AGAST)

include(../../msvc.cmake)

set(SRCDIR ${CMAKE_CURRENT_SOURCE_DIR}/../../src)
set(LIBDIR ${SRCDIR}/AGAST)

add_library(AGAST
        ${LIBDIR}/agast5_8.cc
        ${LIBDIR}/agast5_8_nms.cc
        ${LIBDIR}/agast7_12d.cc
        ${LIBDIR}/agast7_12d_nms.cc
        ${LIBDIR}/agast7_12s.cc
        ${LIBDIR}/agast7_12s_nms.cc
        ${LIBDIR}/nonMaximumSuppression.cc
        ${LIBDIR}/oast9_16.cc
        ${LIBDIR}/oast9_16_nms.cc
)
target_include_directories(AGAST PUBLIC ${SRCDIR})
