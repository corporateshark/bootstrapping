cmake_minimum_required(VERSION 2.8)

project("libVorbis")

if(MSVC)
	add_definitions(
		-D_CRT_SECURE_NO_WARNINGS
	)
	set(CMAKE_C_FLAGS "/EHsc /RTCc /RTC1 /MTd /Zp16 /GS /Qpar /MP /wd4244")
	set(CMAKE_CXX_FLAGS "/EHsc /RTCc /RTC1 /MTd /Zp16 /GS /Qpar /MP /wd4244")
endif(MSVC)

include_directories(
	.
	../../src/libogg/include
	../../src/libvorbis/include
	../../src/libvorbis/lib
)

set(SRC_FILES
	../../src/libvorbis/lib/analysis.c
	../../src/libvorbis/lib/bitrate.c
	../../src/libvorbis/lib/block.c
	../../src/libvorbis/lib/codebook.c
	../../src/libvorbis/lib/envelope.c
	../../src/libvorbis/lib/floor0.c
	../../src/libvorbis/lib/floor1.c
	../../src/libvorbis/lib/info.c
	../../src/libvorbis/lib/lookup.c
	../../src/libvorbis/lib/lpc.c
	../../src/libvorbis/lib/lsp.c
	../../src/libvorbis/lib/mapping0.c
	../../src/libvorbis/lib/mdct.c
	../../src/libvorbis/lib/psy.c
	../../src/libvorbis/lib/registry.c
	../../src/libvorbis/lib/res0.c
	../../src/libvorbis/lib/sharedbook.c
	../../src/libvorbis/lib/smallft.c
	../../src/libvorbis/lib/synthesis.c
	../../src/libvorbis/lib/vorbisfile.c
	../../src/libvorbis/lib/window.c
)

add_library(libVorbis ${SRC_FILES}
	)
