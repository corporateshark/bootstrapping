LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := zlib

LOCAL_C_INCLUDES := \
    $(LOCAL_PATH)/../src/zlib \

LOCAL_EXPORT_C_INCLUDES := \
    $(LOCAL_PATH)/../src/zlib \

LOCAL_SRC_FILES := \
    ../src/zlib/adler32.c \
    ../src/zlib/compress.c \
    ../src/zlib/crc32.c \
    ../src/zlib/deflate.c \
    ../src/zlib/gzclose.c \
    ../src/zlib/gzlib.c \
    ../src/zlib/gzread.c \
    ../src/zlib/gzwrite.c \
    ../src/zlib/infback.c \
    ../src/zlib/inffast.c \
    ../src/zlib/inflate.c \
    ../src/zlib/inftrees.c \
    ../src/zlib/trees.c \
    ../src/zlib/uncompr.c \
    ../src/zlib/zutil.c \

LOCAL_CFLAGS :=
LOCAL_CPPFLAGS :=

ifeq (,$(findstring debug, $(CONFIG)))
    LOCAL_CFLAGS += -fvisibility=hidden
endif

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
LOCAL_CFLAGS += -Wno-shift-negative-value

include $(BUILD_STATIC_LIBRARY)
