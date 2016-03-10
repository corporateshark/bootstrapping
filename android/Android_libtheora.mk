LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := libtheora

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/../src/libogg/include \
	$(LOCAL_PATH)/../src/libtheora \
	$(LOCAL_PATH)/../src/libtheora/include \

LOCAL_SRC_FILES := \
	../src/libtheora/lib/analyze.c \
	../src/libtheora/lib/apiwrapper.c \
	../src/libtheora/lib/bitpack.c \
	../src/libtheora/lib/cpu.c \
	../src/libtheora/lib/decapiwrapper.c \
	../src/libtheora/lib/decinfo.c \
	../src/libtheora/lib/decode.c \
	../src/libtheora/lib/dequant.c \
	../src/libtheora/lib/encapiwrapper.c \
	../src/libtheora/lib/encfrag.c \
	../src/libtheora/lib/encinfo.c \
	../src/libtheora/lib/encode.c \
	../src/libtheora/lib/encoder_disabled.c \
	../src/libtheora/lib/enquant.c \
	../src/libtheora/lib/fdct.c \
	../src/libtheora/lib/fragment.c \
	../src/libtheora/lib/huffdec.c \
	../src/libtheora/lib/huffenc.c \
	../src/libtheora/lib/idct.c \
	../src/libtheora/lib/info.c \
	../src/libtheora/lib/internal.c \
	../src/libtheora/lib/mathops.c \
	../src/libtheora/lib/mcenc.c \
	../src/libtheora/lib/quant.c \
	../src/libtheora/lib/rate.c \
	../src/libtheora/lib/state.c \
	../src/libtheora/lib/tokenize.c

LOCAL_CFLAGS += -O3

LOCAL_CFLAGS += -DTHEORA_DISABLE_ENCODE -DSTDC_HEADERS=1 -DHAVE_UNISTD_H=1 -DHAVE_STDINT_H=1 -Wno-tautological-compare -Wno-shift-op-parentheses -Wno-logical-op-parentheses

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
    LOCAL_ARM_NEON := true
    LOCAL_CFLAGS += -mfpu=neon -march=armv7-a
endif

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a-hard)
    LOCAL_ARM_NEON := true
    LOCAL_CFLAGS += -mfloat-abi=hard -mfpu=neon -march=armv7-a
endif

ifeq ($(TARGET_ARCH_ABI),x86)
	LOCAL_CFLAGS += -m32 -march=i686 -mtune=atom -mssse3 -mfpmath=sse
endif

#   Suppress stupid compiler warnings
LOCAL_CFLAGS += -Wno-parentheses -Wno-shift-negative-value


include $(BUILD_STATIC_LIBRARY)
