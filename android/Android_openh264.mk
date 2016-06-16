LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := openh264

LOCAL_ARM_MODE := arm
LOCAL_C_INCLUDES := \
    $(LOCAL_PATH)/../src/openh264/codec/common/inc \
    $(LOCAL_PATH)/../src/openh264/codec/common \
    $(LOCAL_PATH)/../src/openh264/codec/decoder/core/inc \
    $(LOCAL_PATH)/../src/openh264/codec/decoder/plus/inc \
    $(LOCAL_PATH)/../src/openh264/codec/api/svc \
    $(LOCAL_PATH)/../src/openh264/codec/console/common/inc \
    $(LOCAL_PATH)/../src/openh264/codec/console/dec/inc \
    $(LOCAL_PATH)/../src/openh264/codec/encoder/plus/inc \
    $(LOCAL_PATH)/../src/openh264/codec/encoder/core/inc \
    $(LOCAL_PATH)/../src/openh264/codec/processing/interface \
    $(LOCAL_PATH)/../src/openh264/codec/common/arm

LOCAL_SRC_FILES  := \
	../src/openh264/codec/decoder/core/src/au_parser.cpp \
	../src/openh264/codec/decoder/core/src/bit_stream.cpp \
	../src/openh264/codec/decoder/core/src/cabac_decoder.cpp \
	../src/openh264/codec/decoder/core/src/deblocking.cpp \
	../src/openh264/codec/decoder/core/src/decode_mb_aux.cpp \
	../src/openh264/codec/decoder/core/src/decode_slice.cpp \
	../src/openh264/codec/decoder/core/src/decoder.cpp \
	../src/openh264/codec/decoder/core/src/decoder_core.cpp \
	../src/openh264/codec/decoder/core/src/decoder_data_tables.cpp \
	../src/openh264/codec/decoder/core/src/error_concealment.cpp \
	../src/openh264/codec/decoder/core/src/fmo.cpp \
	../src/openh264/codec/decoder/core/src/get_intra_predictor.cpp \
	../src/openh264/codec/decoder/core/src/manage_dec_ref.cpp \
	../src/openh264/codec/decoder/core/src/memmgr_nal_unit.cpp \
	../src/openh264/codec/decoder/core/src/mv_pred.cpp \
	../src/openh264/codec/decoder/core/src/parse_mb_syn_cabac.cpp \
	../src/openh264/codec/decoder/core/src/parse_mb_syn_cavlc.cpp \
	../src/openh264/codec/decoder/core/src/pic_queue.cpp \
	../src/openh264/codec/decoder/core/src/rec_mb.cpp \
	../src/openh264/codec/decoder/plus/src/welsDecoderExt.cpp \
	../src/openh264/codec/console/dec/src/h264dec.cpp \
	../src/openh264/codec/common/src/common_tables.cpp \
	../src/openh264/codec/common/src/copy_mb.cpp \
	../src/openh264/codec/common/src/cpu.cpp \
	../src/openh264/codec/common/src/crt_util_safe_x.cpp \
	../src/openh264/codec/common/src/deblocking_common.cpp \
	../src/openh264/codec/common/src/expand_pic.cpp \
	../src/openh264/codec/common/src/intra_pred_common.cpp \
	../src/openh264/codec/common/src/mc.cpp \
	../src/openh264/codec/common/src/memory_align.cpp \
	../src/openh264/codec/common/src/sad_common.cpp \
	../src/openh264/codec/common/src/utils.cpp \
	../src/openh264/codec/common/src/welsCodecTrace.cpp \
	../src/openh264/codec/common/src/WelsTaskThread.cpp \
	../src/openh264/codec/common/src/WelsThread.cpp \
	../src/openh264/codec/common/src/WelsThreadLib.cpp \
	../src/openh264/codec/common/src/WelsThreadPool.cpp

LOCAL_CFLAGS := -O3 -ffast-math -Wno-incompatible-pointer-types -Wno-enum-conversion

LOCAL_CFLAGS += -DCODEC_FOR_TESTBED -DANDROID_NDK

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
	LOCAL_ARM_NEON := true
    LOCAL_CFLAGS += -mfpu=neon -march=armv7-a
    LOCAL_CFLAGS += -DUSE_ASM -DHAVE_NEON
	LOCAL_SRC_FILES += ../src/openh264/codec/decoder/core/arm/block_add_neon.S
	LOCAL_SRC_FILES += ../src/openh264/codec/decoder/core/arm/intra_pred_neon.S
	LOCAL_SRC_FILES += ../src/openh264/codec/common/arm/copy_mb_neon.S
	LOCAL_SRC_FILES += ../src/openh264/codec/common/arm/deblocking_neon.S
	LOCAL_SRC_FILES += ../src/openh264/codec/common/arm/expand_picture_neon.S
	LOCAL_SRC_FILES += ../src/openh264/codec/common/arm/intra_pred_common_neon.S
	LOCAL_SRC_FILES += ../src/openh264/codec/common/arm/mc_neon.S
endif

ifeq ($(TARGET_ARCH_ABI),x86)
	LOCAL_CFLAGS += -m32 -march=i686 -mtune=atom -mssse3 -mfpmath=sse
endif

LOCAL_STATIC_LIBRARIES := cpufeatures

include $(BUILD_STATIC_LIBRARY)
