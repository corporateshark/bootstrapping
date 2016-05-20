LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := libyuv

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/../src/libyuv/include

LOCAL_SRC_FILES := \
	../src/libyuv/source/compare.cc \
	../src/libyuv/source/compare_common.cc \
	../src/libyuv/source/compare_gcc.cc \
	../src/libyuv/source/compare_neon.cc \
	../src/libyuv/source/compare_neon64.cc \
	../src/libyuv/source/compare_win.cc \
	../src/libyuv/source/convert.cc \
	../src/libyuv/source/convert_argb.cc \
	../src/libyuv/source/convert_from.cc \
	../src/libyuv/source/convert_from_argb.cc \
	../src/libyuv/source/convert_jpeg.cc \
	../src/libyuv/source/convert_to_argb.cc \
	../src/libyuv/source/convert_to_i420.cc \
	../src/libyuv/source/cpu_id.cc \
	../src/libyuv/source/mjpeg_decoder.cc \
	../src/libyuv/source/mjpeg_validate.cc \
	../src/libyuv/source/planar_functions.cc \
	../src/libyuv/source/rotate.cc \
	../src/libyuv/source/rotate_any.cc \
	../src/libyuv/source/rotate_argb.cc \
	../src/libyuv/source/rotate_common.cc \
	../src/libyuv/source/rotate_gcc.cc \
	../src/libyuv/source/rotate_mips.cc \
	../src/libyuv/source/rotate_neon.cc \
	../src/libyuv/source/rotate_neon64.cc \
	../src/libyuv/source/rotate_win.cc \
	../src/libyuv/source/row_any.cc \
	../src/libyuv/source/row_common.cc \
	../src/libyuv/source/row_gcc.cc \
	../src/libyuv/source/row_mips.cc \
	../src/libyuv/source/row_neon.cc \
	../src/libyuv/source/row_neon64.cc \
	../src/libyuv/source/row_win.cc \
	../src/libyuv/source/scale.cc \
	../src/libyuv/source/scale_any.cc \
	../src/libyuv/source/scale_argb.cc \
	../src/libyuv/source/scale_common.cc \
	../src/libyuv/source/scale_gcc.cc \
	../src/libyuv/source/scale_mips.cc \
	../src/libyuv/source/scale_neon.cc \
	../src/libyuv/source/scale_neon64.cc \
	../src/libyuv/source/scale_win.cc \
	../src/libyuv/source/video_common.cc

LOCAL_CFLAGS += -O3

LOCAL_CFLAGS += -Wno-tautological-compare -Wno-shift-op-parentheses -Wno-logical-op-parentheses

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
    LOCAL_ARM_NEON := true
    #LOCAL_CFLAGS += -mfloat-abi=hard
    LOCAL_CFLAGS += -mfpu=neon -march=armv7-a
    LOCAL_CFLAGS += -DLIBYUV_NEON
endif

ifeq ($(TARGET_ARCH_ABI),x86)
	LOCAL_CFLAGS += -m32 -march=i686 -mtune=atom -mssse3 -mfpmath=sse
endif

#   Suppress stupid compiler warnings
LOCAL_CFLAGS += -Wno-parentheses


include $(BUILD_STATIC_LIBRARY)
