cmake_minimum_required(VERSION 2.8)
project(jpeg-turbo)

set(LIBDIR ${CMAKE_CURRENT_SOURCE_DIR}/../../src/libjpeg-turbo)

include(ExternalProject)

ExternalProject_Add(
    project_jpeg-turbo
    SOURCE_DIR ${LIBDIR}
    CONFIGURE_COMMAND autoreconf -fiv && ${LIBDIR}/configure --prefix=${LIBDIR}/install --host x86_64-apple-darwin NASM=/Users/michael/homebrew/bin/nasm
    PREFIX ${LIBDIR}/install
    BUILD_COMMAND make -j4
    BUILD_IN_SOURCE 1
)

ExternalProject_Get_Property(project_jpeg-turbo install_dir)

add_library(jpeg-turbo STATIC IMPORTED GLOBAL)
set_property(TARGET jpeg-turbo PROPERTY IMPORTED_LOCATION ${install_dir}/lib/libjpeg.a)
add_dependencies(jpeg-turbo project_jpeg-turbo)
set(LIBJPEG_TURBO_INCLUDE_DIR ${install_dir}/include PARENT_SCOPE)
