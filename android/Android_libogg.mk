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

include $(BUILD_STATIC_LIBRARY)
