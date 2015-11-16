cmake_minimum_required(VERSION 2.8)

project("openh264")

if(MSVC)
	set(CMAKE_C_FLAGS "/Ox /EHsc /MT /Zp16 /GS /Qpar /MP /wd4244")
	set(CMAKE_CXX_FLAGS "/Ox /EHsc /MT /Zp16 /GS /Qpar /MP /wd4244")
	set(CMAKE_C_FLAGS_DEBUG "/Ox /EHsc /MT /Zp16 /GS /Qpar /MP /wd4244")
	set(CMAKE_CXX_FLAGS_DEBUG "/Ox /EHsc /MT /Zp16 /GS /Qpar /MP /wd4244")
endif(MSVC)

add_definitions(
	-DCODEC_FOR_TESTBED
)

include_directories(
	.
	../../src/openh264/codec/common/inc
	../../src/openh264/codec/common/
	../../src/openh264/codec/decoder/core/inc
	../../src/openh264/codec/decoder/plus/inc
	../../src/openh264/codec/api/svc
	../../src/openh264/codec/console/common/inc
	../../src/openh264/codec/console/dec/inc
	../../src/openh264/codec/encoder/plus/inc
	../../src/openh264/codec/encoder/core/inc
	../../src/openh264/codec/processing/interface
)

set(SRC_FILES
	../../src/openh264/codec/decoder/core/src/au_parser.cpp
	../../src/openh264/codec/decoder/core/src/bit_stream.cpp
	../../src/openh264/codec/decoder/core/src/cabac_decoder.cpp
	../../src/openh264/codec/decoder/core/src/deblocking.cpp
	../../src/openh264/codec/decoder/core/src/decode_mb_aux.cpp
	../../src/openh264/codec/decoder/core/src/decode_slice.cpp
	../../src/openh264/codec/decoder/core/src/decoder.cpp
	../../src/openh264/codec/decoder/core/src/decoder_core.cpp
	../../src/openh264/codec/decoder/core/src/decoder_data_tables.cpp
	../../src/openh264/codec/decoder/core/src/error_concealment.cpp
	../../src/openh264/codec/decoder/core/src/fmo.cpp
	../../src/openh264/codec/decoder/core/src/get_intra_predictor.cpp
	../../src/openh264/codec/decoder/core/src/manage_dec_ref.cpp
	../../src/openh264/codec/decoder/core/src/memmgr_nal_unit.cpp
	../../src/openh264/codec/decoder/core/src/mv_pred.cpp
	../../src/openh264/codec/decoder/core/src/parse_mb_syn_cabac.cpp
	../../src/openh264/codec/decoder/core/src/parse_mb_syn_cavlc.cpp
	../../src/openh264/codec/decoder/core/src/pic_queue.cpp
	../../src/openh264/codec/decoder/core/src/rec_mb.cpp
	../../src/openh264/codec/decoder/plus/src/welsDecoderExt.cpp
	../../src/openh264/codec/console/dec/src/h264dec.cpp
	../../src/openh264/codec/common/src/common_tables.cpp
	../../src/openh264/codec/common/src/copy_mb.cpp
	../../src/openh264/codec/common/src/cpu.cpp
	../../src/openh264/codec/common/src/crt_util_safe_x.cpp
	../../src/openh264/codec/common/src/deblocking_common.cpp
	../../src/openh264/codec/common/src/expand_pic.cpp
	../../src/openh264/codec/common/src/intra_pred_common.cpp
	../../src/openh264/codec/common/src/mc.cpp
	../../src/openh264/codec/common/src/memory_align.cpp
	../../src/openh264/codec/common/src/sad_common.cpp
	../../src/openh264/codec/common/src/utils.cpp
	../../src/openh264/codec/common/src/welsCodecTrace.cpp
	../../src/openh264/codec/common/src/WelsTaskThread.cpp
	../../src/openh264/codec/common/src/WelsThread.cpp
	../../src/openh264/codec/common/src/WelsThreadLib.cpp
	../../src/openh264/codec/common/src/WelsThreadPool.cpp
)

add_library(openh264 ${SRC_FILES}
	)
