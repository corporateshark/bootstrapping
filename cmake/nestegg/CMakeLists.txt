cmake_minimum_required(VERSION 2.8)

project("nestegg")

if(MSVC)
	set(CMAKE_C_FLAGS "/Ox /EHsc /MT /Zp16 /GS /Qpar /MP /wd4244")
	set(CMAKE_CXX_FLAGS "/Ox /EHsc /MT /Zp16 /GS /Qpar /MP /wd4244")
endif(MSVC)

add_definitions(
)

include_directories(
	.
	../../src/nestegg
	../../src/nestegg/include
	../../src/nestegg/src
	../../src/nestegg/halloc
	../../src/nestegg/halloc/src
)

set(SRC_FILES
	../../src/nestegg/src/nestegg.c
	../../src/nestegg/halloc/src/halloc.c
)

add_library(nestegg ${SRC_FILES}
	)
