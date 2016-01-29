cmake_minimum_required(VERSION 2.8)

# TODO: No longer used, why is this needed?
macro(setup_source_groups src_files)
	foreach(FILE ${src_files})
		get_filename_component(PARENT_DIR "${FILE}" PATH)

		# skip src or include and changes /'s to \\'s
		string(REGEX REPLACE "(\\./)?(src|include)/?" "" GROUP "${PARENT_DIR}")
		string(REPLACE "/" "\\" GROUP "${GROUP}")

		# group into "Source Files" and "Header Files"
		if(${FILE} MATCHES ".*/.+[.]cpp")
			set(GROUP "Source Files\\\\${GROUP}")
		elseif(${FILE} MATCHES ".*/.+[.]hpp")
			set(GROUP "Header Files\\\\${GROUP}")
		endif()

		source_group("${GROUP}" FILES "${FILE}")
	endforeach()
endmacro()

# Process the CMake options
macro(process_cmake_options OPTIONS_INCLUDE_DIRS)

	set(EXTERNAL_ROOT ${CMAKE_CURRENT_LIST_DIR})

	# Local temporary variable to store the resulting include directories
	set(INCLUDE_DIRS )

	if(USE_LIBJPEG)
		if(USE_LIBJPEG_TURBO)
			message(STATUS "Configured with LIBJPEG TURBO support")
			add_definitions(-DBLIPPAR_USE_LIBJPEG_TURBO)
			set(INCLUDE_DIRS ${INCLUDE_DIRS} ${EXTERNAL_ROOT}/src/libjpeg-turbo ${EXTERNAL_ROOT}/src/libjpeg-turbo/include_x86_64 ${EXTERNAL_ROOT}/src/libjpeg-turbo/simd)
		else()
			message(STATUS "Configured with LIBJPEG support")
			add_definitions(-DBLIPPAR_USE_LIBJPEG)
			set(INCLUDE_DIRS ${INCLUDE_DIRS} ${EXTERNAL_ROOT}/src/libjpeg)
		endif()
	endif()

	if(USE_ZLIB)
		message(STATUS "Configured with ZLIB support")
		add_definitions(-DBLIPPAR_USE_ZLIB)
		set(INCLUDE_DIRS ${INCLUDE_DIRS} ${EXTERNAL_ROOT}/src/zlib)
	endif()

	if(USE_BZIP2)
		message(STATUS "Configured with BZIP2 support")
		add_definitions(-DBLIPPAR_USE_BZIP2)
		set(INCLUDE_DIRS ${INCLUDE_DIRS} ${EXTERNAL_ROOT}/src/bzip2)
	endif()

	if(USE_LIBPNG)
		message(STATUS "Configured with LIBPNG support")
		add_definitions(-DBLIPPAR_USE_LIBPNG)
		set(INCLUDE_DIRS ${INCLUDE_DIRS} ${EXTERNAL_ROOT}/src/libpng)
	endif()

	if(USE_GIFLIB)
		message(STATUS "Configured with GIFLIB support")
		add_definitions(-DBLIPPAR_USE_GIFLIB)
		set(INCLUDE_DIRS ${INCLUDE_DIRS} ${EXTERNAL_ROOT}/src/giflib/lib)
	endif()

	if(USE_SNAPPY)
		message(STATUS "Configured with SNAPPY support")
		add_definitions(-DBLIPPAR_USE_SNAPPY)
	endif()

	if(USE_ZOPFLI)
		message(STATUS "Configured with ZOPFLI support")
		add_definitions(-DBLIPPAR_USE_ZOPFLI)
		set(INCLUDE_DIRS ${INCLUDE_DIRS} ${EXTERNAL_ROOT}/src/zopfli/src)
	endif()

	if(USE_BROTLI)
		message(STATUS "Configured with BROTLI support")
		add_definitions(-DBLIPPAR_USE_BROTLI)
	endif()

	if(USE_CAIRO)
		message(STATUS "Configured with CAIRO support")
		add_definitions(-DBLIPPAR_USE_CAIRO)
	endif()

	if(USE_OPENCV)
		message(STATUS "Configured with OPENCV support")
		add_definitions(-DBLIPPAR_USE_OPENCV)
		set(INCLUDE_DIRS ${INCLUDE_DIRS} ${EXTERNAL_ROOT}/src/opencv)
	endif()

	# Stores the result in the 'return' variables
	set(${OPTIONS_INCLUDE_DIRS} ${INCLUDE_DIRS})

endmacro()
