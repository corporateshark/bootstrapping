cmake_minimum_required(VERSION 2.8)

project(external)

option(USE_ZLIB "Use zlib" OFF)
option(USE_BZIP2 "Use bzip2" OFF)
option(USE_LIBJPEG "Use libjpeg" OFF)
option(USE_LIBJPEG_TURBO "Use libjpeg-turbo (if USE_LIBJPEG is ON)" OFF)
option(USE_LIBPNG "Use libpng" OFF)
option(USE_GIFLIB "Use GIFLIB" OFF)
option(USE_ZXING "Use zxing" OFF)
option(USE_AGAST "Use AGAST" OFF)
option(USE_FAST "Use FAST" OFF)
option(USE_ICONV "Use iconv" OFF)
option(USE_ZOPFLI "Use Zopfli" OFF)
option(USE_BROTLI "Use Brotli" OFF)
option(USE_LIBLINEAR "Use liblinear" OFF)

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
    android_mk_static_library(z CFLAGS "\$(EXTERNAL_CFLAGS)")
    android_mk_static_library(gif CFLAGS "\$(EXTERNAL_CFLAGS)")
    android_mk_static_library(png CFLAGS "\$(EXTERNAL_CFLAGS)")
    android_mk_static_library(jpeg CFLAGS "\$(EXTERNAL_CFLAGS)")
    #android_mk_static_library(zxing CFLAGS "\$(EXTERNAL_CFLAGS)" SHARED_LIBRARIES iconv)
    #android_mk_static_library(AGAST CFLAGS "\$(EXTERNAL_CFLAGS)")
    #android_mk_static_library(FAST CFLAGS "\$(EXTERNAL_CFLAGS)")
    #android_mk_shared_library(iconv CFLAGS "\$(EXTERNAL_CFLAGS) -DLIBDIR")
endif()
