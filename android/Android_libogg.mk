LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := ogg

LOCAL_C_INCLUDES := \
	external/src \
		jni/external/src/libogg/include \


LOCAL_SRC_FILES := \
	../src/libogg/src/bitwise.c \
	../src/libogg/src/framing.c \

LOCAL_CFLAGS += -O3

include $(BUILD_STATIC_LIBRARY)
