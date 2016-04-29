cmake_minimum_required(VERSION 2.8)

# Input:
#   - USE_xxxxx options
# Output:
#   - BLIPPAR_INCLUDE_DIRS
#   - BLIPPAR_LIBRARIES

# Options
option(FORCE_EXTERNAL "Force the use of libraries from external; don't use system versions" OFF)
option(BOOTSTRAPPING "Bootstrap external libraries if needed" ON)

#===================================================================================================

# Make macros available to use
set(EXTERNAL_ROOT ${CMAKE_CURRENT_LIST_DIR})
include(${EXTERNAL_ROOT}/macros.cmake)

# Set where 'find_package()' should look
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${EXTERNAL_ROOT}/cmake/")

#===================================================================================================

# Macro to run external bootstrapping for a specific library (if not yet done)
macro(bootstrap_library LIBRARY_TO_BOOTSTRAP)
	if(BOOTSTRAPPING)
		message(STATUS "Running the bootstrapping script to retrieve '${LIBRARY_TO_BOOTSTRAP}'...")
		execute_process(
				COMMAND python bootstrap.py -n ${LIBRARY_TO_BOOTSTRAP}
				WORKING_DIRECTORY ${EXTERNAL_ROOT}
				RESULT_VARIABLE BOOTSTRAP_RESULT
		)
		if(NOT ${BOOTSTRAP_RESULT} STREQUAL "0")
			message(FATAL_ERROR "Bootstrapping failed.")
		endif()
	endif()
endmacro()

# Checks if there is an 'external_libraries.txt' file present. Note that these files are no longer
# needed if the proper USE_LIBRARYNAME options are given: it will automatically boostrap the
# necessary files.
set(EXTERNAL_LIBRARIES_FILE "")
if(EXISTS "${CMAKE_SOURCE_DIR}/external_libraries.txt")
	set(EXTERNAL_LIBRARIES_FILE "${CMAKE_SOURCE_DIR}/external_libraries.txt")
elseif(EXISTS "${CMAKE_SOURCE_DIR}/libs/external_libraries.txt")
	set(EXTERNAL_LIBRARIES_FILE "${CMAKE_SOURCE_DIR}/libs/external_libraries.txt")
endif()

# If there is an 'external_libraries.txt' file present, bootstrap that file
if(NOT ${EXTERNAL_LIBRARIES_FILE} STREQUAL "")
	if(BOOTSTRAPPING)
		message(STATUS "Running the external libraries bootstrapping script (might take a while the first time)...")
		execute_process(
				COMMAND python bootstrap.py -N ${EXTERNAL_LIBRARIES_FILE}
				WORKING_DIRECTORY ${EXTERNAL_ROOT}
				RESULT_VARIABLE BOOTSTRAP_RESULT
		)
		if(NOT ${BOOTSTRAP_RESULT} STREQUAL "0")
			message(FATAL_ERROR "Bootstrapping failed.")
		endif()
	endif()
endif()

#===================================================================================================

# Sets the default build type to release
if(NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Set build configuration" FORCE)
endif()
message(STATUS "Setting build type to '${CMAKE_BUILD_TYPE}'")

# Adds a new address sanitizer build type named 'Sanitizer'
set(CMAKE_CXX_FLAGS_SANITIZER "-O2 -g -fsanitize=address -fno-omit-frame-pointer")
set(CMAKE_C_FLAGS_SANITIZER "-O2 -g -fsanitize=address -fno-omit-frame-pointer")
set(CMAKE_EXE_LINKER_FLAGS_SANITIZER "")
set(CMAKE_SHARED_LINKER_FLAGS_SANITIZER "")
mark_as_advanced(CMAKE_CXX_FLAGS_SANITIZER CMAKE_C_FLAGS_SANITIZER CMAKE_EXE_LINKER_FLAGS_SANITIZER CMAKE_SHARED_LINKER_FLAGS_SANITIZER)

#===================================================================================================

# Compiler flags for Visual Studio
if(MSVC)

	add_definitions(-D_CRT_SECURE_NO_WARNINGS -DNOMINMAX -D_USE_MATH_DEFINES)
	if(COMPILE_FOR_MSVC2013)
		add_definitions(-DBLIPPAR_PLATFORM_COMPILEFOR_MSVC2013)
	endif()

	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP /wd4456 /wd4457 /wd4458 /wd4018 /wd4068 /wd4800 /wd4996 /bigobj")

# Compiler flags for GCC and Clang
else()

	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 -march=native")
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -march=native")

	if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-unknown-pragmas -Wno-maybe-uninitialized -Wno-parentheses")
	elseif ("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang")
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wextra")
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-deprecated-register")
	endif()

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
# This section contains all common and always-used libraries
set(USE_THREAD TRUE)
set(USE_EIGEN TRUE)
set(USE_CATCH TRUE)
set(USE_BOOST TRUE)

# Threading library (pthread on UNIX systems)
if(USE_THREAD)
	find_package(Threads QUIET)
	set(BLIPPAR_LIBRARIES ${BLIPPAR_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT})
endif()

# Eigen: header only from external
if(USE_EIGEN)
	bootstrap_library("eigen")
	set(EIGEN_INCLUDE_DIRS ${EXTERNAL_ROOT}/src/eigen)
	set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${EIGEN_INCLUDE_DIRS})
	message(STATUS "Configured with Eigen: ${EIGEN_INCLUDE_DIRS}")
endif()

# Catch: header only from external
if(USE_CATCH)
	bootstrap_library("catch")
	set(CATCH_INCLUDE_DIRS ${EXTERNAL_ROOT}/src/catch/single_include)
	set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${CATCH_INCLUDE_DIRS})
	message(STATUS "Configured with Catch: ${CATCH_INCLUDE_DIRS}")
endif()

# Use boost in two ways:
# - default: header only
# - when specifying USE_BOOST_COMPONENTS: use specific components
if(USE_BOOST)
	# Searches for a system installation
	if(NOT FORCE_EXTERNAL)
		find_package(Boost 1.58 COMPONENTS ${USE_BOOST_COMPONENTS} QUIET) # https://cmake.org/cmake/help/latest/module/FindBoost.html
	endif()

	# If not found, use the version from "external" instead
	if(NOT Boost_FOUND)
		bootstrap_library("boost")
		set(Boost_INCLUDE_DIRS ${EXTERNAL_ROOT}/src/boost)
		set(Boost_LIBRARIES "")
		set(Boost_LIB_VERSION "1_60")
		if(USE_BOOST_COMPONENTS)
			message(FATAL_ERROR "Boost components required but using version from external (header-only)")
		endif()
	endif()

	set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${Boost_INCLUDE_DIRS})
	set(BLIPPAR_LIBRARIES ${BLIPPAR_LIBRARIES} ${Boost_LIBRARIES})
	message(STATUS "Configured with Boost ${Boost_LIB_VERSION}: ${Boost_INCLUDE_DIRS}")
	if(USE_BOOST_COMPONENTS)
		message(STATUS "Configured with Boost components: ${USE_BOOST_COMPONENTS}")
	endif()
endif()

#===================================================================================================

# Conditionally compiles with CUDA libraries
if(USE_CUDA)
	find_package(CUDA QUIET) # https://cmake.org/cmake/help/v3.1/module/FindCUDA.html
	if(CUDA_FOUND)
		message(STATUS "Configured with CUDA ${CUDA_VERSION_STRING}: ${CUDA_TOOLKIT_ROOT_DIR}")
		link_directories(${CUDA_TOOLKIT_ROOT_DIR}/lib64)
		set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${CUDA_INCLUDE_DIRS})
		set(BLIPPAR_LIBRARIES ${BLIPPAR_LIBRARIES} cuda cudart cublas cusparse cusolver)
		add_definitions(-DBLIPPAR_USE_CUDA)
	endif()
endif()

#===================================================================================================
# This section contains all the external libraries, either taken from the system installation or
# from the external repository. Note that they have to appear in the order in which they should be
# linked, e.g. zlib after libpng because zlib is a dependency of libpng.

if(USE_LIBPNG)
	# Searches for a system installation
	if(NOT FORCE_EXTERNAL)
		find_package(PNG 1.5.9 QUIET) # https://cmake.org/cmake/help/v3.1/module/FindPNG.html
	endif()

	# If not found, use the version from "external" instead
	if(NOT PNG_FOUND)
		bootstrap_library("libpng")
		add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/cmake/png "png" EXCLUDE_FROM_ALL)
		set(PNG_INCLUDE_DIRS ${EXTERNAL_ROOT}/src/libpng)
		set(PNG_LIBRARIES "png")
	endif()

	set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${PNG_INCLUDE_DIRS})
	set(BLIPPAR_LIBRARIES ${BLIPPAR_LIBRARIES} ${PNG_LIBRARIES})
	add_definitions(-DBLIPPAR_USE_LIBPNG)
	message(STATUS "Configured with LIBPNG: ${PNG_INCLUDE_DIRS}")
endif()

if(USE_LIBJPEG)
	if(USE_LIBJPEG_TURBO)
		message(FATAL_ERROR "LIBJPEG_TURBO not supported (for now)")
		# No 'find_package' for LIBJPEG_TURBO available, only looking in "external"
		bootstrap_library("libjpeg-turbo")
		add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/cmake/jpeg-turbo "jpeg-turbo" EXCLUDE_FROM_ALL)
		set(JPEG_INCLUDE_DIR ${EXTERNAL_ROOT}/src/libjpeg-turbo ${EXTERNAL_ROOT}/src/libjpeg-turbo/include_x86_64 ${EXTERNAL_ROOT}/src/libjpeg-turbo/simd)
		set(JPEG_LIBRARIES "jpeg-turbo")

		set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${JPEG_INCLUDE_DIR})
		set(BLIPPAR_LIBRARIES ${BLIPPAR_LIBRARIES} ${JPEG_LIBRARIES})
		add_definitions(-DBLIPPAR_USE_LIBJPEG_TURBO)
		message(STATUS "Configured with LIBJPEG_TURBO: ${JPEG_INCLUDE_DIR}")
	endif()
endif()

if(USE_LIBJPEG)
	if(NOT USE_LIBJPEG_TURBO)
		# Searches for a system installation
		if(NOT FORCE_EXTERNAL)
			find_package(JPEG QUIET) # https://cmake.org/cmake/help/v3.1/module/FindJPEG.html
		endif()

		# If not found, use the version from "external" instead
		if(NOT JPEG_FOUND)
			bootstrap_library("libjpeg")
			add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/cmake/jpeg "jpeg" EXCLUDE_FROM_ALL)
			set(JPEG_INCLUDE_DIR ${EXTERNAL_ROOT}/src/libjpeg)
			set(JPEG_LIBRARIES "jpeg")
		endif()

		set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${JPEG_INCLUDE_DIR})
		set(BLIPPAR_LIBRARIES ${BLIPPAR_LIBRARIES} ${JPEG_LIBRARIES})
		add_definitions(-DBLIPPAR_USE_LIBJPEG)
		message(STATUS "Configured with LIBJPEG: ${JPEG_INCLUDE_DIR}")
	endif()
endif()

if(USE_ZLIB)
	# Searches for a system installation
	if(NOT FORCE_EXTERNAL)
		find_package(ZLIB 1.2.5 QUIET) # https://cmake.org/cmake/help/v3.1/module/FindZLIB.html
	endif()

	# If not found, use the version from "external" instead
	if(NOT ZLIB_FOUND)
		bootstrap_library("zlib")
		add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/cmake/z "z" EXCLUDE_FROM_ALL)
		set(ZLIB_INCLUDE_DIRS ${EXTERNAL_ROOT}/src/zlib)
		set(ZLIB_LIBRARIES "z")
	endif()

	set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${ZLIB_INCLUDE_DIRS})
	set(BLIPPAR_LIBRARIES ${BLIPPAR_LIBRARIES} ${ZLIB_LIBRARIES})
	add_definitions(-DBLIPPAR_USE_ZLIB)
	message(STATUS "Configured with ZLIB: ${ZLIB_INCLUDE_DIRS}")
endif()

if(USE_BZIP2)
	# Searches for a system installation
	if(NOT FORCE_EXTERNAL)
		find_package(BZip2 QUIET) # https://cmake.org/cmake/help/v3.1/module/FindBZip2.html
	endif()

	# If not found, use the version from "external" instead
	if(NOT BZIP2_FOUND)
		bootstrap_library("bzip2")
		add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/cmake/bz2 "bz2" EXCLUDE_FROM_ALL)
		set(BZIP2_INCLUDE_DIR ${EXTERNAL_ROOT}/src/bzip2)
		set(BZIP2_LIBRARIES "z")
	endif()

	set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${BZIP2_INCLUDE_DIR})
	set(BLIPPAR_LIBRARIES ${BLIPPAR_LIBRARIES} ${BZIP2_LIBRARIES})
	add_definitions(-DBLIPPAR_USE_BZIP2)
	message(STATUS "Configured with BZIP2: ${BZIP2_INCLUDE_DIR}")
endif()

if(USE_GIFLIB)
	# Searches for a system installation
	if(NOT FORCE_EXTERNAL)
		find_package(GIF QUIET) # https://cmake.org/cmake/help/v3.1/module/FindGIF.html
	endif()

	# If not found, use the version from "external" instead
	if(NOT GIF_FOUND)
		bootstrap_library("giflib")
		add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/cmake/gif "gif" EXCLUDE_FROM_ALL)
		set(GIF_INCLUDE_DIR ${EXTERNAL_ROOT}/src/giflib/lib)
		set(GIF_LIBRARIES "z")
	endif()

	set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${GIF_INCLUDE_DIR})
	set(BLIPPAR_LIBRARIES ${BLIPPAR_LIBRARIES} ${GIF_LIBRARIES})
	add_definitions(-DBLIPPAR_USE_GIFLIB)
	message(STATUS "Configured with GIFLIB: ${GIF_INCLUDE_DIR}")
endif()

if(USE_ZOPFLI)
	# No 'find_package' for ZOPFLI available, only looking in "external"
	bootstrap_library("zopfli")
	add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/cmake/zopfli "zopfli" EXCLUDE_FROM_ALL)
	set(ZOPFLI_INCLUDE_DIR ${EXTERNAL_ROOT}/src/zopfli/src)
	set(ZOPFLI_LIBRARIES "zopfli")

	set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${ZOPFLI_INCLUDE_DIR})
	set(BLIPPAR_LIBRARIES ${BLIPPAR_LIBRARIES} ${ZOPFLI_LIBRARIES})
	add_definitions(-DBLIPPAR_USE_ZOPFLI)
	message(STATUS "Configured with ZOPFLI: ${ZOPFLI_INCLUDE_DIR}")
endif()

if(USE_BROTLI)
	# No 'find_package' for BROTLI available, only looking in "external"
	bootstrap_library("brotli")
	add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/cmake/brotli "brotli" EXCLUDE_FROM_ALL)
	set(BROTLI_INCLUDE_DIR ${EXTERNAL_ROOT}/src)
	set(BROTLI_LIBRARIES "brotli")

	set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${BROTLI_INCLUDE_DIR})
	set(BLIPPAR_LIBRARIES ${BLIPPAR_LIBRARIES} ${BROTLI_LIBRARIES})
	add_definitions(-DBLIPPAR_USE_BROTLI)
	message(STATUS "Configured with BROTLI: ${BROTLI_INCLUDE_DIR}")
endif()

if(USE_CAIRO)
	# Searches for a system installation; no version available in "external"
	find_package(Cairo REQUIRED QUIET) # From "external/cmake/FindCairo.cmake"

	set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${CAIRO_INCLUDE_DIRS})
	set(BLIPPAR_LIBRARIES ${BLIPPAR_LIBRARIES} ${CAIRO_LIBRARIES})
	add_definitions(-DBLIPPAR_USE_CAIRO)
	message(STATUS "Configured with CAIRO: ${CAIRO_INCLUDE_DIRS}")
endif()

if(USE_SNAPPY)
	# Ignored for now; no 'find_package' available and no custom CMake file either
	message(STATUS "SNAPPY support unavailable; please set -DUSE_SNAPPY=OFF")
endif()

# OpenCV
if(USE_OPENCV)
	# Searches for a system installation. This assumes 'FindOpenCV.cmake' is available somewhere on
	# the system. This is available when OpenCV is installed. If not, this will generate an error.
	find_package(OpenCV QUIET)

	set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${OpenCV_INCLUDE_DIRS})
	set(BLIPPAR_LIBRARIES ${BLIPPAR_LIBRARIES} ${OpenCV_LIBS})
	add_definitions(-DBLIPPAR_USE_OPENCV)
	message(STATUS "Configured with OPENCV: ${OpenCV_INCLUDE_DIRS}")
endif()

# Torch
if(USE_TORCH)
	find_package(Torch REQUIRED)
#	find_package(CUDA 7.5 REQUIRED))

	set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${Torch_INSTALL_INCLUDE})
	link_directories(${Torch_INSTALL_LIB})                                                                                                                                                                                     
	set(BLIPPAR_LIBRARIES ${BLIPPAR_LIBRARIES} 
			TH
			luaT
			luajit
	)
	add_definitions(-DBLIPPAR_USE_TORCH)
	message(STATUS "Configured with Torch: ${Torch_INSTALL_INCLUDE}")
endif()

if(USE_LIBLINEAR)
	# No 'find_package' for LIBLINEAR available, only looking in "external"
	bootstrap_library("liblinear")
	add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/cmake/liblinear "liblinear" EXCLUDE_FROM_ALL)
	set(LIBLINEAR_INCLUDE_DIR ${EXTERNAL_ROOT}/src/liblinear)
	set(LIBLINEAR_LIBRARIES "liblinear")

	set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${LIBLINEAR_INCLUDE_DIR})
	set(BLIPPAR_LIBRARIES ${BLIPPAR_LIBRARIES} ${LIBLINEAR_LIBRARIES})
	add_definitions(-DBLIPPAR_USE_LIBLINEAR)
	message(STATUS "Configured with LIBLINEAR: ${LIBLINEAR_INCLUDE_DIR}")
endif()

if(USE_ZXING)
	# No 'find_package' for ZXING available, only looking in "external"
	bootstrap_library("zxing")
	add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/cmake/zxing "zxing" EXCLUDE_FROM_ALL)
	set(ZXING_INCLUDE_DIR ${EXTERNAL_ROOT}/src/zxing)
	set(ZXING_LIBRARIES "zxing")

	set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${ZXING_INCLUDE_DIR})
	set(BLIPPAR_LIBRARIES ${BLIPPAR_LIBRARIES} ${ZXING_LIBRARIES})
	add_definitions(-DBLIPPAR_USE_ZXING)
	message(STATUS "Configured with ZXING: ${ZXING_INCLUDE_DIR}")
endif()

if(USE_AGAST)
	# No 'find_package' for AGAST available, only looking in "external"
	bootstrap_library("agast")
	add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/cmake/AGAST "agast" EXCLUDE_FROM_ALL)
	set(AGAST_INCLUDE_DIR ${EXTERNAL_ROOT}/src/agast)
	set(AGAST_LIBRARIES "AGAST")

	set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${AGAST_INCLUDE_DIR})
	set(BLIPPAR_LIBRARIES ${BLIPPAR_LIBRARIES} ${AGAST_LIBRARIES})
	add_definitions(-DBLIPPAR_USE_AGAST)
	message(STATUS "Configured with AGAST: ${AGAST_INCLUDE_DIR}")
endif()

if(USE_FAST)
	# No 'find_package' for FAST available, only looking in "external"
	bootstrap_library("fast")
	add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/cmake/FAST "fast" EXCLUDE_FROM_ALL)
	set(FAST_INCLUDE_DIR ${EXTERNAL_ROOT}/src/fast)
	set(FAST_LIBRARIES "FAST")

	set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${FAST_INCLUDE_DIR})
	set(BLIPPAR_LIBRARIES ${BLIPPAR_LIBRARIES} ${FAST_LIBRARIES})
	add_definitions(-DBLIPPAR_USE_FAST)
	message(STATUS "Configured with FAST: ${FAST_INCLUDE_DIR}")
endif()

if(USE_ICONV)
	# No 'find_package' for ICONV available, only looking in "external"
	bootstrap_library("iconv")
	add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/cmake/iconv "iconv" EXCLUDE_FROM_ALL)
	set(ICONV_INCLUDE_DIR ${EXTERNAL_ROOT}/src)
	set(ICONV_LIBRARIES "iconv")

	set(BLIPPAR_INCLUDE_DIRS ${BLIPPAR_INCLUDE_DIRS} ${ICONV_INCLUDE_DIR})
	set(BLIPPAR_LIBRARIES ${BLIPPAR_LIBRARIES} ${ICONV_LIBRARIES})
	add_definitions(-DBLIPPAR_USE_ICONV)
	message(STATUS "Configured with ICONV: ${ICONV_INCLUDE_DIR}")
endif()

#===================================================================================================

# Conditionally compiles with OpenMP (for multi-threaded Eigen)
if(USE_OPENMP)
	find_package(OpenMP) # https://cmake.org/cmake/help/v3.1/module/FindOpenMP.html
	if(OPENMP_FOUND)
		message(STATUS "Enabling OpenMP")
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
		set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
	endif()
endif()

#===================================================================================================
