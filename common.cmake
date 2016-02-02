cmake_minimum_required(VERSION 2.8)

# Input:
#   - USE_xxxxx options
# Output:
#   - BLIPPAR_INCLUDE_DIRS

#===================================================================================================

# Make macros available to use
set(EXTERNAL_ROOT ${CMAKE_CURRENT_LIST_DIR})
include(${EXTERNAL_ROOT}/macros.cmake)

# Sets the default build type to release
if(NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Set build configuration" FORCE)
endif()
message(STATUS "Setting build type to '${CMAKE_BUILD_TYPE}'")

#===================================================================================================

# Compiler flags for Visual Studio
if(MSVC)

	add_definitions(-D_CRT_SECURE_NO_WARNINGS -DNOMINMAX)
	if(COMPILE_FOR_MSVC2013)
		add_definitions(-DBLIPPAR_PLATFORM_COMPILEFOR_MSVC2013)
	endif()

	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP /wd4456 /wd4457 /wd4458 /wd4018 /wd4068 /wd4800 /wd4996 /bigobj")

# Compiler flags for GCC and Clang
else()

	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 -march=native")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-deprecated-declarations -Wno-deprecated-declarations -Wno-gnu-designator -Wno-unknown-pragmas")
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -march=native")

	# TODO: Auto-detect whether or not ARM NEON is supported by the hardware
	if(HAVE_NEON)
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mfloat-abi=hard -mfpu=neon")
	endif()

endif()

# Uses LLVM's libc++ because Apple doesn't support 'std::shared_timed_mutex'
if (CMAKE_CXX_COMPILER_ID MATCHES "Clang" AND DEFINED LLVM_ROOT)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++ -nostdinc++ -I${LLVM_ROOT}/include/c++/v1 -L${LLVM_ROOT}/lib -Qunused-arguments")
	add_definitions(-DBLIPPAR_USE_CUSTOM_LIBCXX)
	message (STATUS "Using custom libc++ from ${LLVM_ROOT}")
endif()

#===================================================================================================

# Requires boost. Note: set "BOOST_ROOT" to point to a custom Boost installation
# https://cmake.org/cmake/help/latest/module/FindBoost.html
find_package(Boost 1.58 REQUIRED)
if(Boost_FOUND)
	set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${Boost_INCLUDE_DIRS})
endif()

#===================================================================================================
# TODO: Substitute these with FindPackage and optionally find system versions

# LIBJPEG (from external)
if(USE_LIBJPEG)
	if(USE_LIBJPEG_TURBO)
		message(STATUS "Configured with LIBJPEG TURBO support")
		add_definitions(-DBLIPPAR_USE_LIBJPEG_TURBO)
		add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/cmake/jpeg-turbo "jpeg-turbo" EXCLUDE_FROM_ALL)
		set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${EXTERNAL_ROOT}/src/libjpeg-turbo ${EXTERNAL_ROOT}/src/libjpeg-turbo/include_x86_64 ${EXTERNAL_ROOT}/src/libjpeg-turbo/simd)
	else()
		message(STATUS "Configured with LIBJPEG support")
		add_definitions(-DBLIPPAR_USE_LIBJPEG)
		add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/cmake/jpeg "jpeg" EXCLUDE_FROM_ALL)
		set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${EXTERNAL_ROOT}/src/libjpeg)
	endif()
endif()

# ZLIB (from external)
if(USE_ZLIB)
	message(STATUS "Configured with ZLIB support")
	add_definitions(-DBLIPPAR_USE_ZLIB)
	add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/cmake/z "z" EXCLUDE_FROM_ALL)
	set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${EXTERNAL_ROOT}/src/zlib)
endif()

# BZIP2 (from external)
if(USE_BZIP2)
	message(STATUS "Configured with BZIP2 support")
	add_definitions(-DBLIPPAR_USE_BZIP2)
	add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/cmake/bz2 "bz2" EXCLUDE_FROM_ALL)
	set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${EXTERNAL_ROOT}/src/bzip2)
endif()

# PNG (from external)
if(USE_LIBPNG)
	message(STATUS "Configured with LIBPNG support")
	add_definitions(-DBLIPPAR_USE_LIBPNG)
	add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/cmake/png "png" EXCLUDE_FROM_ALL)
	set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${EXTERNAL_ROOT}/src/libpng)
endif()

# GIFLIB (from external)
if(USE_GIFLIB)
	message(STATUS "Configured with GIFLIB support")
	add_definitions(-DBLIPPAR_USE_GIFLIB)
	add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/cmake/gif "gif" EXCLUDE_FROM_ALL)
	set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${EXTERNAL_ROOT}/src/giflib/lib)
endif()

# Snappy
if(USE_SNAPPY)
	message(STATUS "Configured with SNAPPY support")
	add_definitions(-DBLIPPAR_USE_SNAPPY)
endif()

# ZOPFLI (from external)
if(USE_ZOPFLI)
	message(STATUS "Configured with ZOPFLI support")
	add_definitions(-DBLIPPAR_USE_ZOPFLI)
	add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/cmake/zopfli "zopfli" EXCLUDE_FROM_ALL)
	set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${EXTERNAL_ROOT}/src/zopfli/src)
endif()

# BROTLI (from external)
if(USE_BROTLI)
	message(STATUS "Configured with BROTLI support")
	add_definitions(-DBLIPPAR_USE_BROTLI)
	add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/cmake/brotli "brotli" EXCLUDE_FROM_ALL)
endif()

# Cairo
if(USE_CAIRO)
	message(STATUS "Configured with CAIRO support")
	add_definitions(-DBLIPPAR_USE_CAIRO)
endif()

# OpenCV
if(USE_OPENCV)
	message(STATUS "Configured with OPENCV support")
	add_definitions(-DBLIPPAR_USE_OPENCV)
	set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${EXTERNAL_ROOT}/src/opencv)
endif()

#===================================================================================================

# Conditionally compiles with OpenMP (for multi-threaded Eigen)
if(USE_OPENMP)
	find_package(OpenMP)
	if(OPENMP_FOUND)
		message(STATUS "Enabling OpenMP")
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
	endif()
endif()

#===================================================================================================
