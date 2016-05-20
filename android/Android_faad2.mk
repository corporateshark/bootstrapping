LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := libfaad2

LOCAL_ARM_MODE := arm
LOCAL_C_INCLUDES := \
    $(LOCAL_PATH)/../src/faad2/libfaad \
    $(LOCAL_PATH)/../src/faad2/include

LOCAL_SRC_FILES  := \
	../src/faad2/libfaad/bits.c \
	../src/faad2/libfaad/cfft.c \
	../src/faad2/libfaad/common.c \
	../src/faad2/libfaad/decoder.c \
	../src/faad2/libfaad/drc.c \
	../src/faad2/libfaad/drm_dec.c \
	../src/faad2/libfaad/error.c \
	../src/faad2/libfaad/filtbank.c \
	../src/faad2/libfaad/hcr.c \
	../src/faad2/libfaad/huffman.c \
	../src/faad2/libfaad/ic_predict.c \
	../src/faad2/libfaad/is.c \
	../src/faad2/libfaad/lt_predict.c \
	../src/faad2/libfaad/mdct.c \
	../src/faad2/libfaad/mp4.c \
	../src/faad2/libfaad/ms.c \
	../src/faad2/libfaad/output.c \
	../src/faad2/libfaad/pns.c \
	../src/faad2/libfaad/ps_dec.c \
	../src/faad2/libfaad/ps_syntax.c \
	../src/faad2/libfaad/pulse.c \
	../src/faad2/libfaad/rvlc.c \
	../src/faad2/libfaad/sbr_dct.c \
	../src/faad2/libfaad/sbr_dec.c \
	../src/faad2/libfaad/sbr_e_nf.c \
	../src/faad2/libfaad/sbr_fbt.c \
	../src/faad2/libfaad/sbr_hfadj.c \
	../src/faad2/libfaad/sbr_hfgen.c \
	../src/faad2/libfaad/sbr_huff.c \
	../src/faad2/libfaad/sbr_qmf.c \
	../src/faad2/libfaad/sbr_syntax.c \
	../src/faad2/libfaad/sbr_tf_grid.c \
	../src/faad2/libfaad/specrec.c \
	../src/faad2/libfaad/ssr.c \
	../src/faad2/libfaad/ssr_fb.c \
	../src/faad2/libfaad/ssr_ipqf.c \
	../src/faad2/libfaad/syntax.c \
	../src/faad2/libfaad/tns.c

LOCAL_CFLAGS := -O3 -ffast-math -Wno-incompatible-pointer-types -Wno-enum-conversion

LOCAL_CFLAGS += \
	-DHAVE_LRINTF \
	-DHAVE_COSF \
	-DHAVE_LOGF \
	-DHAVE_EXPF \
	-DHAVE_FLOORF \
	-DHAVE_CEILF \
	-DHAVE_SQRTF \
	-DSTDC_HEADERS \
	-DHAVE_MEMCPY \
	-DHAVE_STRCHR \
	-DHAVE_SYS_TYPES_H \
	-DHAVE_SYS_STAT_H \
	-DHAVE_STDLIB_H \
	-DHAVE_STRING_H \
	-DHAVE_STDINT_H

LOCAL_CFLAGS += -Wno-tautological-constant-out-of-range-compare

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
    LOCAL_ARM_NEON := true
    LOCAL_CFLAGS += -mfloat-abi=hard -mfpu=neon -march=armv7-a
endif

ifeq ($(TARGET_ARCH_ABI),x86)
	LOCAL_CFLAGS += -m32 -march=i686 -mtune=atom -mssse3 -mfpmath=sse
endif

include $(BUILD_STATIC_LIBRARY)
