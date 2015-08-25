LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := libopenal-soft

LOCAL_ARM_MODE := arm
LOCAL_C_INCLUDES := \
    external/src/openal-soft-android \
    external/src/openal-soft-android/include \
    external/src/openal-soft-android/OpenAL32/Include \
    external/src/openal-soft-android/Alc \

LOCAL_SRC_FILES  := \
    ../src/openal-soft-android/OpenAL32/alAuxEffectSlot.c \
    ../src/openal-soft-android/OpenAL32/alBuffer.c        \
    ../src/openal-soft-android/OpenAL32/alEffect.c        \
    ../src/openal-soft-android/OpenAL32/alError.c         \
    ../src/openal-soft-android/OpenAL32/alExtension.c     \
    ../src/openal-soft-android/OpenAL32/alFilter.c        \
    ../src/openal-soft-android/OpenAL32/alListener.c      \
    ../src/openal-soft-android/OpenAL32/alSource.c        \
    ../src/openal-soft-android/OpenAL32/alState.c         \
    ../src/openal-soft-android/OpenAL32/alThunk.c         \
    ../src/openal-soft-android/Alc/ALc.c                  \
    ../src/openal-soft-android/Alc/alcConfig.c            \
    ../src/openal-soft-android/Alc/alcEcho.c              \
    ../src/openal-soft-android/Alc/alcModulator.c         \
    ../src/openal-soft-android/Alc/alcReverb.c            \
    ../src/openal-soft-android/Alc/alcRing.c              \
    ../src/openal-soft-android/Alc/alcThread.c            \
    ../src/openal-soft-android/Alc/ALu.c                  \
    ../src/openal-soft-android/Alc/backends/android.c     \
    ../src/openal-soft-android/Alc/bs2b.c                 \
    ../src/openal-soft-android/Alc/null.c                 \


LOCAL_CFLAGS     := -ffast-math -DAL_BUILD_LIBRARY -DAL_ALEXT_PROTOTYPES -Wno-incompatible-pointer-types -Wno-enum-conversion -DHAVE_ANDROID=1

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a-hard)
	LOCAL_ARM_NEON := true
	LOCAL_CFLAGS += -mfloat-abi=hard -mfpu=neon -march=armv7-a
endif

include $(BUILD_STATIC_LIBRARY)
