cmake_minimum_required(VERSION 2.8)

project(external)

set(USE_ZLIB OFF CACHE BOOL "Use zlib")
set(USE_BZIP2 OFF CACHE BOOL "Use bzip2")
set(USE_LIBJPEG OFF CACHE BOOL "Use libjpeg")
set(USE_LIBJPEG_TURBO OFF CACHE BOOL "Use libjpeg-turbo (if USE_LIBJPEG is ON)")
set(USE_LIBPNG OFF CACHE BOOL "Use libpng")
set(USE_GIFLIB OFF CACHE BOOL "Use GIFLIB")
set(USE_ZXING OFF CACHE BOOL "Use zxing")
set(USE_AGAST OFF CACHE BOOL "Use AGAST")
set(USE_FAST OFF CACHE BOOL "Use FAST")
set(USE_ICONV OFF CACHE BOOL "Use iconv")
set(USE_ZOPFLI OFF CACHE BOOL "Use Zopfli")
set(USE_BROTLI OFF CACHE BOOL "Use Brotli")
set(USE_LIBLINEAR OFF CACHE BOOL "Use liblinear")

if (USE_ZLIB)
    add_subdirectory(./cmake/z EXCLUDE_FROM_ALL)
endif()

if (USE_BZIP2)
    add_subdirectory(./cmake/bz2 EXCLUDE_FROM_ALL)
endif()

if (USE_LIBJPEG)
    add_subdirectory(./cmake/jpeg EXCLUDE_FROM_ALL)
endif()

if (USE_LIBJPEG_TURBO)
    #add_subdirectory(./cmake/jpeg-turbo EXCLUDE_FROM_ALL)
endif()

if (USE_LIBPNG)
    add_subdirectory(./cmake/png EXCLUDE_FROM_ALL)
endif()

if (USE_GIFLIB)
    add_subdirectory(./cmake/gif EXCLUDE_FROM_ALL)
endif()

if (USE_ZXING)
    add_subdirectory(./cmake/zxing EXCLUDE_FROM_ALL)
endif()

if (USE_AGAST)
    add_subdirectory(./cmake/AGAST EXCLUDE_FROM_ALL)
endif()

if (USE_FAST)
    add_subdirectory(./cmake/FAST EXCLUDE_FROM_ALL)
endif()

if (USE_ICONV)
    add_subdirectory(./cmake/iconv EXCLUDE_FROM_ALL)
endif()

if(USE_BROTLI)
    add_subdirectory(./cmake/brotli EXCLUDE_FROM_ALL)
endif()

if(USE_ZOPFLI)
    add_subdirectory(./cmake/zopfli EXCLUDE_FROM_ALL)
endif()

if(USE_LIBLINEAR)
    add_subdirectory(./cmake/liblinear EXCLUDE_FROM_ALL)
endif()

if (ANDROID_MK)
    android_mk_create()
    android_mk_static_library(gif CFLAGS "\$(EXTERNAL_CFLAGS)")
    android_mk_static_library(png CFLAGS "\$(EXTERNAL_CFLAGS)")
    android_mk_static_library(jpeg CFLAGS "\$(EXTERNAL_CFLAGS)")
    android_mk_static_library(zxing CFLAGS "\$(EXTERNAL_CFLAGS)" SHARED_LIBRARIES iconv)
    android_mk_static_library(AGAST CFLAGS "\$(EXTERNAL_CFLAGS)")
    android_mk_static_library(FAST CFLAGS "\$(EXTERNAL_CFLAGS)")
    android_mk_shared_library(iconv CFLAGS "\$(EXTERNAL_CFLAGS) -DLIBDIR")
endif()
