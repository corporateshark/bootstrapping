cmake_minimum_required(VERSION 2.8)

project("faad2")

if(MSVC)
	set(CMAKE_C_FLAGS "/EHsc /RTC1 /MTd /Zp16 /GS /Qpar /MP /wd4244")
	set(CMAKE_CXX_FLAGS "/EHsc /RTC1 /MTd /Zp16 /GS /Qpar /MP /wd4244")
endif(MSVC)

if(APPLE)
    add_definitions(-DHAVE_STDINT_H)
endif(APPLE)

add_definitions(
	-D__MINGW32__
	-DHAVE_LRINTF
	-DHAVE_COSF
	-DHAVE_LOGF
	-DHAVE_EXPF
	-DHAVE_FLOORF
	-DHAVE_CEILF
	-DHAVE_SQRTF
	-DSTDC_HEADERS
	-DHAVE_MEMCPY
	-DHAVE_STRCHR
)

include_directories(
	.
	../../src/faad2/libfaad
	../../src/faad2/include
)

set(SRC_FILES
	../../src/faad2/libfaad/bits.c
	../../src/faad2/libfaad/cfft.c
	../../src/faad2/libfaad/common.c
	../../src/faad2/libfaad/decoder.c
	../../src/faad2/libfaad/drc.c
	../../src/faad2/libfaad/drm_dec.c
	../../src/faad2/libfaad/error.c
	../../src/faad2/libfaad/filtbank.c
	../../src/faad2/libfaad/hcr.c
	../../src/faad2/libfaad/huffman.c
	../../src/faad2/libfaad/ic_predict.c
	../../src/faad2/libfaad/is.c
	../../src/faad2/libfaad/lt_predict.c
	../../src/faad2/libfaad/mdct.c
	../../src/faad2/libfaad/mp4.c
	../../src/faad2/libfaad/ms.c
	../../src/faad2/libfaad/output.c
	../../src/faad2/libfaad/pns.c
	../../src/faad2/libfaad/ps_dec.c
	../../src/faad2/libfaad/ps_syntax.c
	../../src/faad2/libfaad/pulse.c
	../../src/faad2/libfaad/rvlc.c
	../../src/faad2/libfaad/sbr_dct.c
	../../src/faad2/libfaad/sbr_dec.c
	../../src/faad2/libfaad/sbr_e_nf.c
	../../src/faad2/libfaad/sbr_fbt.c
	../../src/faad2/libfaad/sbr_hfadj.c
	../../src/faad2/libfaad/sbr_hfgen.c
	../../src/faad2/libfaad/sbr_huff.c
	../../src/faad2/libfaad/sbr_qmf.c
	../../src/faad2/libfaad/sbr_syntax.c
	../../src/faad2/libfaad/sbr_tf_grid.c
	../../src/faad2/libfaad/specrec.c
	../../src/faad2/libfaad/ssr.c
	../../src/faad2/libfaad/ssr_fb.c
	../../src/faad2/libfaad/ssr_ipqf.c
	../../src/faad2/libfaad/syntax.c
	../../src/faad2/libfaad/tns.c
)

add_library(faad2 ${SRC_FILES}
	)
