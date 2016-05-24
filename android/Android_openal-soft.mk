LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := libopenal-soft

LOCAL_ARM_MODE := arm
LOCAL_C_INCLUDES := \
    $(LOCAL_PATH)/../src/openal-android \
    $(LOCAL_PATH)/../src/openal-soft/include \
    $(LOCAL_PATH)/../src/openal-soft/OpenAL32/Include \
    $(LOCAL_PATH)/../src/openal-soft/Alc

LOCAL_SRC_FILES  := \
    ../src/openal-soft/OpenAL32/alAuxEffectSlot.c \
    ../src/openal-soft/OpenAL32/alBuffer.c \
    ../src/openal-soft/OpenAL32/alEffect.c \
    ../src/openal-soft/OpenAL32/alError.c \
    ../src/openal-soft/OpenAL32/alExtension.c \
    ../src/openal-soft/OpenAL32/alFilter.c \
    ../src/openal-soft/OpenAL32/alListener.c \
    ../src/openal-soft/OpenAL32/alSource.c \
    ../src/openal-soft/OpenAL32/alState.c \
    ../src/openal-soft/OpenAL32/alThunk.c \
    ../src/openal-soft/Alc/ALc.c \
    ../src/openal-soft/Alc/alcConfig.c \
    ../src/openal-soft/Alc/alcDedicated.c \
    ../src/openal-soft/Alc/alcEcho.c \
    ../src/openal-soft/Alc/alcModulator.c \
    ../src/openal-soft/Alc/alcReverb.c \
    ../src/openal-soft/Alc/alcRing.c \
    ../src/openal-soft/Alc/alcThread.c \
    ../src/openal-soft/Alc/ALu.c \
    ../src/openal-soft/Alc/bs2b.c \
    ../src/openal-soft/Alc/helpers.c \
    ../src/openal-soft/Alc/hrtf.c \
    ../src/openal-soft/Alc/mixer.c \
    ../src/openal-soft/Alc/mixer_c.c \
    ../src/openal-soft/Alc/panning.c \
    ../src/openal-soft/Alc/backends/loopback.c \
    ../src/openal-soft/Alc/backends/null.c \
    ../src/openal-soft/Alc/backends/opensl.c

LOCAL_CFLAGS := -O2 -ffast-math -DAL_BUILD_LIBRARY -DAL_ALEXT_PROTOTYPES -Wno-incompatible-pointer-types -Wno-enum-conversion

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
    LOCAL_ARM_NEON := true
    LOCAL_CFLAGS += -mfpu=neon -march=armv7-a
    LOCAL_CFLAGS += -D_ARM_ASSEM_
endif

ifeq ($(TARGET_ARCH_ABI),x86)
	LOCAL_CFLAGS += -m32 -march=i686 -mtune=atom -mssse3 -mfpmath=sse
endif

include $(BUILD_STATIC_LIBRARY)
