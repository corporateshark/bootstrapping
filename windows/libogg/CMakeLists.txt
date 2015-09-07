cmake_minimum_required(VERSION 2.8)

project("libOGG")

if(MSVC)
	add_definitions(
		-D_CRT_SECURE_NO_WARNINGS
		-DHAVE_CONFIG_H
	)
	set(CMAKE_C_FLAGS "/EHsc /RTC1 /MTd /Zp16 /GS /Qpar /MP /wd4244")
	set(CMAKE_CXX_FLAGS "/EHsc /RTC1 /MTd /Zp16 /GS /Qpar /MP /wd4244")
endif(MSVC)

include_directories(
	.
	../../src/libogg/src
	../../src/libogg/include
)

set(SRC_FILES
	../../src/libogg/src/bitwise.c
	../../src/libogg/src/framing.c
)

add_library(libOGG ${SRC_FILES}
	)
