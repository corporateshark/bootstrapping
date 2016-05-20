LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := libpng

LOCAL_C_INCLUDES := \
    $(LOCAL_PATH)/../src/zlib \
    $(LOCAL_PATH)/../src/libpng \

LOCAL_EXPORT_C_INCLUDES := \
    $(LOCAL_PATH)/../src/zlib \
    $(LOCAL_PATH)/../src/libpng \

LOCAL_SRC_FILES := \
    ../src/libpng/png.c \
    ../src/libpng/pngerror.c \
    ../src/libpng/pngget.c \
    ../src/libpng/pngmem.c \
    ../src/libpng/pngpread.c \
    ../src/libpng/pngread.c \
    ../src/libpng/pngrio.c \
    ../src/libpng/pngrtran.c \
    ../src/libpng/pngrutil.c \
    ../src/libpng/pngset.c \
    ../src/libpng/pngtrans.c \
    ../src/libpng/pngwio.c \
    ../src/libpng/pngwrite.c \
    ../src/libpng/pngwtran.c \
    ../src/libpng/pngwutil.c \
    ../src/libpng/arm/arm_init.c \
    ../src/libpng/arm/filter_neon_intrinsics.c \

LOCAL_CFLAGS :=
LOCAL_CPPFLAGS :=

ifeq (,$(findstring debug, $(CONFIG)))
    LOCAL_CFLAGS += -fvisibility=hidden
endif

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
    LOCAL_ARM_NEON := true
    LOCAL_CPPFLAGS += -mfloat-abi=hard -mfpu=neon -march=armv7-a
endif

ifeq ($(TARGET_ARCH_ABI),x86)
	LOCAL_CPPFLAGS += -m32 -march=i686 -mtune=atom -mssse3 -mfpmath=sse
endif

include $(BUILD_STATIC_LIBRARY)
