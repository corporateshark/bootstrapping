cmake_minimum_required(VERSION 2.8)

project("libvpx")

if(MSVC)
	set(CMAKE_C_FLAGS "/EHsc /RTC1 /MTd /Zp16 /GS /Qpar /MP /wd4244")
	set(CMAKE_CXX_FLAGS "/EHsc /RTC1 /MTd /Zp16 /GS /Qpar /MP /wd4244")
endif(MSVC)

add_definitions(
)

include_directories(
	.
	../../src/libvpx/build
	../../src/libvpx
	../../src/libvpx/test
	../../src/libvpx/vp8
	../../src/libvpx/vp9
	../../src/libvpx/vp10
	../../src/libvpx/vpx_mem/include
	../../src/libvpx/vpx_mem/memory_manager/include
)

set(SRC_FILES
	../../src/libvpx/args.c
	../../src/libvpx/ivfdec.c
	../../src/libvpx/md5_utils.c
	../../src/libvpx/rate_hist.c
	../../src/libvpx/tools_common.c
	../../src/libvpx/video_reader.c
	../../src/libvpx/video_writer.c
	../../src/libvpx/vpxstats.c
	../../src/libvpx/warnings.c
	../../src/libvpx/y4menc.c
	../../src/libvpx/y4minput.c
	../../src/libvpx/webmdec.cc
	../../src/libvpx/video_reader.c
	../../src/libvpx/third_party/libwebm/mkvmuxer.cpp
	../../src/libvpx/third_party/libwebm/mkvmuxerutil.cpp
	../../src/libvpx/third_party/libwebm/mkvparser.cpp
	../../src/libvpx/third_party/libwebm/mkvreader.cpp
	../../src/libvpx/third_party/libwebm/mkvwriter.cpp
)

if(MSVC)
	set(SRC_FILES
		${SRC_FILES}
	)
else(MSVC)
	set(SRC_FILES
		${SRC_FILES}
	)
endif(MSVC)

add_library(libvpx ${SRC_FILES}
	)
