LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := nestegg

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/../src/nestegg \
	$(LOCAL_PATH)/../src/nestegg/include \
	$(LOCAL_PATH)/../src/nestegg/src \
	$(LOCAL_PATH)/../src/nestegg/halloc \
	$(LOCAL_PATH)/../src/nestegg/halloc/src

LOCAL_SRC_FILES := \
	../src/nestegg/src/nestegg.c \
	../src/nestegg/halloc/src/halloc.c

LOCAL_CFLAGS += -O3

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

include $(BUILD_STATIC_LIBRARY)
