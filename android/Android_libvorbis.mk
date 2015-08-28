LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := libvorbis

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/../src/libvorbis/include \
	$(LOCAL_PATH)/../src/libogg/include \
	$(LOCAL_PATH)/../../BlippEngine/Audio \

LOCAL_SRC_FILES := \
	../src/libvorbis/lib/analysis.c \
	../src/libvorbis/lib/bitrate.c \
	../src/libvorbis/lib/block.c \
	../src/libvorbis/lib/codebook.c \
	../src/libvorbis/lib/envelope.c \
	../src/libvorbis/lib/floor0.c \
	../src/libvorbis/lib/floor1.c \
	../src/libvorbis/lib/info.c \
	../src/libvorbis/lib/lookup.c \
	../src/libvorbis/lib/lpc.c \
	../src/libvorbis/lib/lsp.c \
	../src/libvorbis/lib/mapping0.c \
	../src/libvorbis/lib/mdct.c \
	../src/libvorbis/lib/psy.c \
	../src/libvorbis/lib/registry.c \
	../src/libvorbis/lib/res0.c \
	../src/libvorbis/lib/sharedbook.c \
	../src/libvorbis/lib/smallft.c \
	../src/libvorbis/lib/synthesis.c \
	../src/libvorbis/lib/vorbisfile.c \
	../src/libvorbis/lib/window.c \

LOCAL_CFLAGS += -O3

include $(BUILD_STATIC_LIBRARY)
