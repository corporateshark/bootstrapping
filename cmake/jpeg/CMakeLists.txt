cmake_minimum_required(VERSION 2.8)
project(jpeg)

include(../../msvc.cmake)

set(SRCDIR ${CMAKE_CURRENT_SOURCE_DIR}/../../src)
set(LIBDIR ${SRCDIR}/libjpeg)

add_library(jpeg
        ${LIBDIR}/jaricom.c
        ${LIBDIR}/jcapimin.c
        ${LIBDIR}/jcapistd.c
        ${LIBDIR}/jcarith.c
        ${LIBDIR}/jccoefct.c
        ${LIBDIR}/jccolor.c
        ${LIBDIR}/jcdctmgr.c
        ${LIBDIR}/jchuff.c
        ${LIBDIR}/jcinit.c
        ${LIBDIR}/jcmainct.c
        ${LIBDIR}/jcmarker.c
        ${LIBDIR}/jcmaster.c
        ${LIBDIR}/jcomapi.c
        ${LIBDIR}/jcparam.c
        ${LIBDIR}/jcprepct.c
        ${LIBDIR}/jcsample.c
        ${LIBDIR}/jctrans.c
        ${LIBDIR}/jdapimin.c
        ${LIBDIR}/jdapistd.c
        ${LIBDIR}/jdarith.c
        ${LIBDIR}/jdatadst.c
        ${LIBDIR}/jdatasrc.c
        ${LIBDIR}/jdcoefct.c
        ${LIBDIR}/jdcolor.c
        ${LIBDIR}/jddctmgr.c
        ${LIBDIR}/jdhuff.c
        ${LIBDIR}/jdinput.c
        ${LIBDIR}/jdmainct.c
        ${LIBDIR}/jdmarker.c
        ${LIBDIR}/jdmaster.c
        ${LIBDIR}/jdmerge.c
        ${LIBDIR}/jdpostct.c
        ${LIBDIR}/jdsample.c
        ${LIBDIR}/jdtrans.c
        ${LIBDIR}/jerror.c
        ${LIBDIR}/jfdctflt.c
        ${LIBDIR}/jfdctfst.c
        ${LIBDIR}/jfdctint.c
        ${LIBDIR}/jidctflt.c
        ${LIBDIR}/jidctfst.c
        ${LIBDIR}/jidctint.c
        ${LIBDIR}/jmemnobs.c
        ${LIBDIR}/jmemmgr.c
        ${LIBDIR}/jquant1.c
        ${LIBDIR}/jquant2.c
        ${LIBDIR}/jutils.c
)
target_include_directories(jpeg PUBLIC ${LIBDIR})