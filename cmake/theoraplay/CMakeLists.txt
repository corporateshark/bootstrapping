cmake_minimum_required(VERSION 2.8)

project("theoraplay")

if(MSVC)
	add_definitions(
		-D_CRT_SECURE_NO_WARNINGS
		-Dinline=__inline
	)
	set(CMAKE_C_FLAGS "/EHsc /RTC1 /MTd /Zp16 /GS /Qpar /MP /wd4244 /wd4700")
	set(CMAKE_CXX_FLAGS "/EHsc /RTC1 /MTd /Zp16 /GS /Qpar /MP /wd4244 /wd4700")
endif(MSVC)

include_directories(
	.
	../../src/libogg/include
	../../src/libvorbis/include
	../../src/libvorbis/lib
	../../src/libtheora/include
	../../src/libtheora/lib
	../../src/theoraplay
)

set(SRC_FILES
	../../src/theoraplay/theoraplay.c
)

add_library(theoraplay ${SRC_FILES}
	)
