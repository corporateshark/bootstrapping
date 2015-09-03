cmake_minimum_required(VERSION 2.8)
project(jpeg-turbo)

# AT THE MOMENT, THIS FILE IS NOT SUITABLE FOR BUILDING LIBJPEG-TURBO ON ANY PLATFORM!
# TODO: FIX
# PLEASE USE THE PROVIDED MAKEFILE ./android/Android_libjpeg-turbo.mk FOR ANDROID.

include(../../msvc.cmake)

set(SRCDIR ${CMAKE_CURRENT_SOURCE_DIR}/../../src)
set(LIBDIR ${SRCDIR}/libjpeg-turbo)

add_library(jpeg-turbo
    ${LIBDIR}/jcapimin.c
    ${LIBDIR}/jcapistd.c
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
    ${LIBDIR}/jcphuff.c
    ${LIBDIR}/jcprepct.c
    ${LIBDIR}/jcsample.c
    ${LIBDIR}/jctrans.c
    ${LIBDIR}/jdapimin.c
    ${LIBDIR}/jdapistd.c
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
    ${LIBDIR}/jdphuff.c
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
    ${LIBDIR}/jidctred.c
    ${LIBDIR}/jquant1.c
    ${LIBDIR}/jquant2.c
    ${LIBDIR}/jutils.c
    ${LIBDIR}/jmemmgr.c
    ${LIBDIR}/jmemnobs.c
    ${LIBDIR}/jaricom.c
    ${LIBDIR}/jcarith.c
    ${LIBDIR}/jdarith.c
    ${LIBDIR}/turbojpeg.c
    ${LIBDIR}/transupp.c
    ${LIBDIR}/jdatadst-tj.c
    ${LIBDIR}/jdatasrc-tj.c
    ${LIBDIR}/simd/jsimd_x86_64.c
    ${LIBDIR}/simd/jfdctflt-sse-64.asm
    ${LIBDIR}/simd/jccolor-sse2-64.asm
    ${LIBDIR}/simd/jcgray-sse2-64.asm
    ${LIBDIR}/simd/jcsample-sse2-64.asm
    ${LIBDIR}/simd/jdcolor-sse2-64.asm
    ${LIBDIR}/simd/jdmerge-sse2-64.asm
    ${LIBDIR}/simd/jdsample-sse2-64.asm
    ${LIBDIR}/simd/jfdctfst-sse2-64.asm
    ${LIBDIR}/simd/jfdctint-sse2-64.asm
    ${LIBDIR}/simd/jidctflt-sse2-64.asm
    ${LIBDIR}/simd/jidctfst-sse2-64.asm
    ${LIBDIR}/simd/jidctint-sse2-64.asm
    ${LIBDIR}/simd/jidctred-sse2-64.asm
    ${LIBDIR}/simd/jquantf-sse2-64.asm
    ${LIBDIR}/simd/jquanti-sse2-64.asm
)

target_include_directories(jpeg-turbo
    PUBLIC ${LIBDIR} ${LIBDIR}/include_x86_64 ${LIBDIR}/simd)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DINLINE=\"inline __attribute__((always_inline))\"")

##############
enable_language(ASM_NASM)
set(CMAKE_ASM_NASM_COMPILER "nasm")
#set(CMAKE_ASM_NASM_FLAGS_INIT "-I${CMAKE_CURRENT_SOURCE_DIR}/src/")
##############

#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}
#        -DC_ARITH_CODING_SUPPORTED=1 -DD_ARITH_CODING_SUPPORTED=1 -DBITS_IN_JSAMPLE=8 -DHAVE_DLFCN_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_LOCALE_H=1 -DHAVE_MEMCPY=1
#        -DHAVE_MEMORY_H=1 -DHAVE_MEMSET=1 -DHAVE_STDDEF_H=1 -DHAVE_STDINT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRINGS_H=1 -DHAVE_STRING_H=1 -DHAVE_SYS_STAT_H=1
#        -DHAVE_SYS_TYPES_H=1 -DHAVE_UNISTD_H=1 -DHAVE_UNSIGNED_CHAR=1 -DHAVE_UNSIGNED_SHORT=1 -DINLINE=\"inline __attribute__((always_inline))\" -DJPEG_LIB_VERSION=62
#        -DMEM_SRCDST_SUPPORTED=1 -DNEED_SYS_TYPES_H=1 -DSTDC_HEADERS=1 -DWITH_SIMD=1 -DSIZEOF_SIZE_T=8")

#LOCAL_ASMFLAGS += -D__x86_64__


