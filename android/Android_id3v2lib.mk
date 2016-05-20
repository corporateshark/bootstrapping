LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := id3v2lib

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/../src/id3v2lib \
	$(LOCAL_PATH)/../src/id3v2lib/include \
	$(LOCAL_PATH)/../src/id3v2lib/include/id3v2lib

LOCAL_SRC_FILES := \
	../src/id3v2lib/src/frame.c \
	../src/id3v2lib/src/header.c \
	../src/id3v2lib/src/id3v2lib.c \
	../src/id3v2lib/src/types.c \
	../src/id3v2lib/src/utils.c

LOCAL_CFLAGS += -O3

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
    LOCAL_ARM_NEON := true
    LOCAL_CFLAGS += -mfloat-abi=hard -mfpu=neon -march=armv7-a
endif

ifeq ($(TARGET_ARCH_ABI),x86)
	LOCAL_CFLAGS += -m32 -march=i686 -mtune=atom -mssse3 -mfpmath=sse
endif

include $(BUILD_STATIC_LIBRARY)
