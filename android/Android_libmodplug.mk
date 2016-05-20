LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := libmodplug

LOCAL_C_INCLUDES += \
	$(LOCAL_PATH)/../src/libmodplug \
	$(LOCAL_PATH)/../src/libmodplug/src \
	$(LOCAL_PATH)/../src/libmodplug/src/libmodplug \

LOCAL_SRC_FILES := \
	../src/libmodplug/src/fastmix.cpp \
	../src/libmodplug/src/load_669.cpp \
	../src/libmodplug/src/load_amf.cpp \
	../src/libmodplug/src/load_ams.cpp \
	../src/libmodplug/src/load_dbm.cpp \
	../src/libmodplug/src/load_dmf.cpp \
	../src/libmodplug/src/load_dsm.cpp \
	../src/libmodplug/src/load_far.cpp \
	../src/libmodplug/src/load_it.cpp \
	../src/libmodplug/src/load_j2b.cpp \
	../src/libmodplug/src/load_mdl.cpp \
	../src/libmodplug/src/load_med.cpp \
	../src/libmodplug/src/load_mid.cpp \
	../src/libmodplug/src/load_mod.cpp \
	../src/libmodplug/src/load_mt2.cpp \
	../src/libmodplug/src/load_mtm.cpp \
	../src/libmodplug/src/load_okt.cpp \
	../src/libmodplug/src/load_pat.cpp \
	../src/libmodplug/src/load_psm.cpp \
	../src/libmodplug/src/load_ptm.cpp \
	../src/libmodplug/src/load_s3m.cpp \
	../src/libmodplug/src/load_stm.cpp \
	../src/libmodplug/src/load_ult.cpp \
	../src/libmodplug/src/load_umx.cpp \
	../src/libmodplug/src/load_wav.cpp \
	../src/libmodplug/src/load_xm.cpp \
	../src/libmodplug/src/mmcmp.cpp \
	../src/libmodplug/src/modplug.cpp \
	../src/libmodplug/src/snd_dsp.cpp \
	../src/libmodplug/src/snd_flt.cpp \
	../src/libmodplug/src/snd_fx.cpp \
	../src/libmodplug/src/sndfile.cpp \
	../src/libmodplug/src/sndmix.cpp

LOCAL_CFLAGS += -O3

LOCAL_CPPFLAGS += -DHAVE_CONFIG_H -DMODPLUG_BUILD -DMODPLUG_STATIC -DMODPLUG_NO_FILESAVE -DMODPLUG_BASIC_SUPPORT -Wno-enum-conversion -Wno-deprecated-register

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
    LOCAL_ARM_NEON := true
    LOCAL_CFLAGS += -mfloat-abi=hard -mfpu=neon -march=armv7-a
endif

ifeq ($(TARGET_ARCH_ABI),x86)
	LOCAL_CFLAGS += -m32 -march=i686 -mtune=atom -mssse3 -mfpmath=sse
endif

include $(BUILD_STATIC_LIBRARY)
