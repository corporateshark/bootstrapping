LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := libtremolo

LOCAL_C_INCLUDES := external/src

LOCAL_SRC_FILES := \
	../src/libtremolo/annotate.c \
	../src/libtremolo/bitwise.c \
	../src/libtremolo/codebook.c \
	../src/libtremolo/dsp.c \
	../src/libtremolo/floor_lookup.c \
	../src/libtremolo/floor0.c \
	../src/libtremolo/floor1.c \
	../src/libtremolo/framing.c \
	../src/libtremolo/info.c \
	../src/libtremolo/mapping0.c \
	../src/libtremolo/mdct.c \
	../src/libtremolo/res012.c \
	../src/libtremolo/vorbisfile.c

LOCAL_CFLAGS += -O3 -Wno-implicit-function-declaration

#LOCAL_CPPFLAGS += -DONLY_C

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a-hard)
	LOCAL_ARM_NEON := true
	LOCAL_CFLAGS += -mfloat-abi=hard -mfpu=neon -march=armv7-a
endif

LOCAL_ARM_MODE := arm
LOCAL_SRC_FILES += \
	../src/libtremolo/bitwiseARM.s \
	../src/libtremolo/dpen.s \
	../src/libtremolo/floor1ARM.s \
	../src/libtremolo/mdctARM.s

include $(BUILD_STATIC_LIBRARY)
