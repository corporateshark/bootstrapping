cmake_minimum_required(VERSION 2.8)

project("libyuv")

if(MSVC)
	add_definitions(
	)
	set(CMAKE_C_FLAGS "/Ox /EHsc /MT /Zp16 /GS /Qpar /MP /wd4244")
	set(CMAKE_CXX_FLAGS "/Ox /EHsc /MT /Zp16 /GS /Qpar /MP /wd4244")
	set(CMAKE_C_FLAGS_DEBUG "/Ox /EHsc /MT /Zp16 /GS /Qpar /MP /wd4244")
	set(CMAKE_CXX_FLAGS_DEBUG "/Ox /EHsc /MT /Zp16 /GS /Qpar /MP /wd4244")
endif(MSVC)

include_directories(
	.
	../../src/libyuv/include
)

set(SRC_FILES
	../../src/libyuv/source/compare.cc
	../../src/libyuv/source/compare_common.cc
	../../src/libyuv/source/compare_gcc.cc
	../../src/libyuv/source/compare_neon.cc
	../../src/libyuv/source/compare_neon64.cc
	../../src/libyuv/source/compare_win.cc
	../../src/libyuv/source/convert.cc
	../../src/libyuv/source/convert_argb.cc
	../../src/libyuv/source/convert_from.cc
	../../src/libyuv/source/convert_from_argb.cc
	../../src/libyuv/source/convert_jpeg.cc
	../../src/libyuv/source/convert_to_argb.cc
	../../src/libyuv/source/convert_to_i420.cc
	../../src/libyuv/source/cpu_id.cc
	../../src/libyuv/source/mjpeg_decoder.cc
	../../src/libyuv/source/mjpeg_validate.cc
	../../src/libyuv/source/planar_functions.cc
	../../src/libyuv/source/rotate.cc
	../../src/libyuv/source/rotate_any.cc
	../../src/libyuv/source/rotate_argb.cc
	../../src/libyuv/source/rotate_common.cc
	../../src/libyuv/source/rotate_gcc.cc
	../../src/libyuv/source/rotate_mips.cc
	../../src/libyuv/source/rotate_neon.cc
	../../src/libyuv/source/rotate_neon64.cc
	../../src/libyuv/source/rotate_win.cc
	../../src/libyuv/source/row_any.cc
	../../src/libyuv/source/row_common.cc
	../../src/libyuv/source/row_gcc.cc
	../../src/libyuv/source/row_mips.cc
	../../src/libyuv/source/row_neon.cc
	../../src/libyuv/source/row_neon64.cc
	../../src/libyuv/source/row_win.cc
	../../src/libyuv/source/scale.cc
	../../src/libyuv/source/scale_any.cc
	../../src/libyuv/source/scale_argb.cc
	../../src/libyuv/source/scale_common.cc
	../../src/libyuv/source/scale_gcc.cc
	../../src/libyuv/source/scale_mips.cc
	../../src/libyuv/source/scale_neon.cc
	../../src/libyuv/source/scale_neon64.cc
	../../src/libyuv/source/scale_win.cc
	../../src/libyuv/source/video_common.cc
)

add_library(libyuv ${SRC_FILES}
	)
