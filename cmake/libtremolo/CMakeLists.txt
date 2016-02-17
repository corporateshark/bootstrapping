cmake_minimum_required(VERSION 2.8)

project("libTremolo")

if(MSVC)
	add_definitions(
		-D_CRT_SECURE_NO_WARNINGS
	)
	set(CMAKE_C_FLAGS "/EHsc /Zp16 /GS /Qpar /MP /wd4244")
	set(CMAKE_CXX_FLAGS "/EHsc /Zp16 /GS /Qpar /MP /wd4244")
endif(MSVC)

add_definitions(
	-DONLY_C
)

include_directories(
	.
)

set(SRC_FILES
	../../src/libtremolo/annotate.c
	../../src/libtremolo/bitwise.c
	../../src/libtremolo/codebook.c
	../../src/libtremolo/dsp.c
	../../src/libtremolo/floor_lookup.c
	../../src/libtremolo/floor0.c
	../../src/libtremolo/floor1.c
	../../src/libtremolo/framing.c
	../../src/libtremolo/info.c
	../../src/libtremolo/mapping0.c
	../../src/libtremolo/mdct.c
	../../src/libtremolo/res012.c
	../../src/libtremolo/vorbisfile.c
)

set(HEADER_FILES
	../../src/libtremolo/asm_arm.h
	../../src/libtremolo/codebook.h
	../../src/libtremolo/codec_internal.h
	../../src/libtremolo/config_types.h
	../../src/libtremolo/ivorbiscodec.h
	../../src/libtremolo/ivorbisfile.h
	../../src/libtremolo/lsp_lookup.h
	../../src/libtremolo/mdct.h
	../../src/libtremolo/mdct_lookup.h
	../../src/libtremolo/misc.h
	../../src/libtremolo/ogg.h
	../../src/libtremolo/os.h
	../../src/libtremolo/os_types.h
	../../src/libtremolo/window_lookup.h
)

add_library(libTremolo ${SRC_FILES} ${HEADER_FILES}
	)
