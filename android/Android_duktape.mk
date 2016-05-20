LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := duktape

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/../src/duktape/src

LOCAL_SRC_FILES := \
	../src/duktape/src/duktape.c

LOCAL_CFLAGS += -O3

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
    LOCAL_ARM_NEON := true
    LOCAL_CFLAGS += -mfloat-abi=hard -mfpu=neon -march=armv7-a
endif

ifeq ($(TARGET_ARCH_ABI),x86)
	LOCAL_CFLAGS += -m32 -march=i686 -mtune=atom -mssse3 -mfpmath=sse
endif

LOCAL_CFLAGS += -Wno-parentheses-equality

include $(BUILD_STATIC_LIBRARY)
