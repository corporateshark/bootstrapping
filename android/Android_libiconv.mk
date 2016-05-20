LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := libiconv

LOCAL_C_INCLUDES += \
	$(LOCAL_PATH)/../src/libiconv/src \
	$(LOCAL_PATH)/../src/libiconv/include \
	$(LOCAL_PATH)/../src/libiconv/lib \
	$(LOCAL_PATH)/../src/libiconv/srclib

LOCAL_SRC_FILES := \
	../src/libiconv/lib/iconv.c \
	../src/libiconv/lib/relocatable.c \
	../src/libiconv/libcharset/lib/localcharset.c

LOCAL_CFLAGS :=
LOCAL_CPPFLAGS :=

LOCAL_CFLAGS += -O3
LOCAL_CFLAGS += -DLIBDIR 

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
    LOCAL_ARM_NEON := true
    LOCAL_CFLAGS += -mfloat-abi=hard -mfpu=neon -march=armv7-a
endif

ifeq ($(TARGET_ARCH_ABI),x86)
	LOCAL_CFLAGS += -m32 -march=i686 -mtune=atom -mssse3 -mfpmath=sse
endif

include $(BUILD_STATIC_LIBRARY)
