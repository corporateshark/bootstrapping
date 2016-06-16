LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := libogg

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/../src/libogg \
	$(LOCAL_PATH)/../src/libogg/include \
	$(LOCAL_PATH)/../../BlippEngine/Audio \

LOCAL_SRC_FILES := \
	../src/libogg/src/bitwise.c \
	../src/libogg/src/framing.c \

LOCAL_CFLAGS += -O3

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
    LOCAL_ARM_NEON := true
    LOCAL_CFLAGS += -mfpu=neon -march=armv7-a
endif

ifeq ($(TARGET_ARCH_ABI),x86)
	LOCAL_CFLAGS += -m32 -march=i686 -mtune=atom -mssse3 -mfpmath=sse
endif

include $(BUILD_STATIC_LIBRARY)
