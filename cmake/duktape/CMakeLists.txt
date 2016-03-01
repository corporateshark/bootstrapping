cmake_minimum_required(VERSION 2.8)
project(duktape)

include(../../msvc.cmake)

set(SRCDIR ${CMAKE_CURRENT_SOURCE_DIR}/../../src)
set(LIBDIR ${SRCDIR}/duktape/src)

add_library(duktape
        ${LIBDIR}/duktape.c
        ${LIBDIR}/duktape.h
        ${LIBDIR}/duk_config.h
        )

target_include_directories(duktape INTERFACE ${LIB_DIR})