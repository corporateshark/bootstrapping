cmake_minimum_required(VERSION 2.8)

project("libTheora")

if(MSVC)
	add_definitions(
		-D_CRT_SECURE_NO_WARNINGS
		-DOC_X86_ASM
		-DTHEORA_DISABLE_ENCODE
		-DSTDC_HEADERS=1
		-DHAVE_UNISTD_H=1
		-DHAVE_STDINT_H=1
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
)

set(SRC_FILES
	../../src/libtheora/lib/analyze.c
	../../src/libtheora/lib/apiwrapper.c
	../../src/libtheora/lib/bitpack.c
	../../src/libtheora/lib/cpu.c
	../../src/libtheora/lib/decapiwrapper.c
	../../src/libtheora/lib/decinfo.c
	../../src/libtheora/lib/decode.c
	../../src/libtheora/lib/dequant.c
	../../src/libtheora/lib/encapiwrapper.c
	../../src/libtheora/lib/encfrag.c
	../../src/libtheora/lib/encinfo.c
	../../src/libtheora/lib/encode.c
	../../src/libtheora/lib/encoder_disabled.c
	../../src/libtheora/lib/enquant.c
	../../src/libtheora/lib/fdct.c
	../../src/libtheora/lib/fragment.c
	../../src/libtheora/lib/huffdec.c
	../../src/libtheora/lib/huffenc.c
	../../src/libtheora/lib/idct.c
	../../src/libtheora/lib/info.c
	../../src/libtheora/lib/internal.c
	../../src/libtheora/lib/mathops.c
	../../src/libtheora/lib/mcenc.c
	../../src/libtheora/lib/quant.c
	../../src/libtheora/lib/rate.c
	../../src/libtheora/lib/state.c
	../../src/libtheora/lib/tokenize.c
)

if(MSVC)
set(SRC_FILES
	${SRC_FILES}
	../../src/libtheora/lib/x86_vc/mmxencfrag.c
	../../src/libtheora/lib/x86_vc/mmxfdct.c
	../../src/libtheora/lib/x86_vc/mmxfrag.c
	../../src/libtheora/lib/x86_vc/mmxidct.c
	../../src/libtheora/lib/x86_vc/mmxstate.c
	../../src/libtheora/lib/x86_vc/x86enc.c
	../../src/libtheora/lib/x86_vc/x86state.c
)
else(MSVC)
set(SRC_FILES
	${SRC_FILES}
	../../src/libtheora/lib/x86/mmxencfrag.c
	../../src/libtheora/lib/x86/mmxfdct.c
	../../src/libtheora/lib/x86/mmxfrag.c
	../../src/libtheora/lib/x86/mmxidct.c
	../../src/libtheora/lib/x86/mmxstate.c
	../../src/libtheora/lib/x86/sse2fdct.c
	../../src/libtheora/lib/x86/x86enc.c
	../../src/libtheora/lib/x86/x86state.c
)
endif(MSVC)

add_library(libTheora ${SRC_FILES}
	)
