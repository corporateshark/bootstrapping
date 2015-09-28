cmake_minimum_required(VERSION 2.8)

project(brotli)

include(../../msvc.cmake)

set(SRCDIR ${CMAKE_CURRENT_SOURCE_DIR}/../../src)
set(LIBDIR ${SRCDIR}/brotli)

if (NOT MSVC)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
endif()

add_library(brotli STATIC
    ${LIBDIR}/dec/bit_reader.c
    ${LIBDIR}/dec/decode.c
    ${LIBDIR}/dec/dictionary.c
    ${LIBDIR}/dec/huffman.c
    ${LIBDIR}/dec/state.c
    ${LIBDIR}/dec/streams.c
    ${LIBDIR}/enc/backward_references.cc
    ${LIBDIR}/enc/block_splitter.cc
    ${LIBDIR}/enc/brotli_bit_stream.cc
    ${LIBDIR}/enc/encode.cc
    ${LIBDIR}/enc/encode_parallel.cc
    ${LIBDIR}/enc/entropy_encode.cc
    ${LIBDIR}/enc/histogram.cc
    ${LIBDIR}/enc/literal_cost.cc
    ${LIBDIR}/enc/metablock.cc
    ${LIBDIR}/enc/static_dict.cc
    ${LIBDIR}/enc/streams.cc
)

target_include_directories(brotli
    PUBLIC
    ./dec
    ./enc
)