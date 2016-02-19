LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := libfdk-aac

LOCAL_ARM_MODE := arm
LOCAL_C_INCLUDES := \
    $(LOCAL_PATH)/../src/fdk-aac/libAACdec/include \
    $(LOCAL_PATH)/../src/fdk-aac/libFDK/include \
    $(LOCAL_PATH)/../src/fdk-aac/libSYS/include \
    $(LOCAL_PATH)/../src/fdk-aac/libMpegTPDec/include \
    $(LOCAL_PATH)/../src/fdk-aac/libSBRdec/include \
    $(LOCAL_PATH)/../src/fdk-aac/libPCMutils/include \

LOCAL_SRC_FILES  := \
	../src/fdk-aac/libAACdec/src/aac_ram.cpp \
	../src/fdk-aac/libAACdec/src/aac_rom.cpp \
	../src/fdk-aac/libAACdec/src/aacdec_drc.cpp \
	../src/fdk-aac/libAACdec/src/aacdec_hcr.cpp \
	../src/fdk-aac/libAACdec/src/aacdec_hcr_bit.cpp \
	../src/fdk-aac/libAACdec/src/aacdec_hcrs.cpp \
	../src/fdk-aac/libAACdec/src/aacdec_pns.cpp \
	../src/fdk-aac/libAACdec/src/aacdec_tns.cpp \
	../src/fdk-aac/libAACdec/src/aacdecoder.cpp \
	../src/fdk-aac/libAACdec/src/aacdecoder_lib.cpp \
	../src/fdk-aac/libAACdec/src/block.cpp \
	../src/fdk-aac/libAACdec/src/channel.cpp \
	../src/fdk-aac/libAACdec/src/channelinfo.cpp \
	../src/fdk-aac/libAACdec/src/conceal.cpp \
	../src/fdk-aac/libAACdec/src/ldfiltbank.cpp \
	../src/fdk-aac/libAACdec/src/pulsedata.cpp \
	../src/fdk-aac/libAACdec/src/rvlc.cpp \
	../src/fdk-aac/libAACdec/src/rvlcbit.cpp \
	../src/fdk-aac/libAACdec/src/rvlcconceal.cpp \
	../src/fdk-aac/libAACdec/src/stereo.cpp \
	../src/fdk-aac/libFDK/src/autocorr2nd.cpp \
	../src/fdk-aac/libFDK/src/dct.cpp \
	../src/fdk-aac/libFDK/src/FDK_bitbuffer.cpp \
	../src/fdk-aac/libFDK/src/FDK_core.cpp \
	../src/fdk-aac/libFDK/src/FDK_crc.cpp \
	../src/fdk-aac/libFDK/src/FDK_hybrid.cpp \
	../src/fdk-aac/libFDK/src/FDK_tools_rom.cpp \
	../src/fdk-aac/libFDK/src/FDK_trigFcts.cpp \
	../src/fdk-aac/libFDK/src/fft.cpp \
	../src/fdk-aac/libFDK/src/fft_rad2.cpp \
	../src/fdk-aac/libFDK/src/fixpoint_math.cpp \
	../src/fdk-aac/libFDK/src/mdct.cpp \
	../src/fdk-aac/libFDK/src/qmf.cpp \
	../src/fdk-aac/libFDK/src/scale.cpp \
	../src/fdk-aac/libSYS/src/cmdl_parser.cpp \
	../src/fdk-aac/libSYS/src/conv_string.cpp \
	../src/fdk-aac/libSYS/src/genericStds.cpp \
	../src/fdk-aac/libSYS/src/wav_file.cpp \
	../src/fdk-aac/libMpegTPDec/src/tpdec_adif.cpp \
	../src/fdk-aac/libMpegTPDec/src/tpdec_adts.cpp \
	../src/fdk-aac/libMpegTPDec/src/tpdec_asc.cpp \
	../src/fdk-aac/libMpegTPDec/src/tpdec_latm.cpp \
	../src/fdk-aac/libMpegTPDec/src/tpdec_lib.cpp \
	../src/fdk-aac/libSBRdec/src/env_calc.cpp \
	../src/fdk-aac/libSBRdec/src/env_dec.cpp \
	../src/fdk-aac/libSBRdec/src/env_extr.cpp \
	../src/fdk-aac/libSBRdec/src/huff_dec.cpp \
	../src/fdk-aac/libSBRdec/src/lpp_tran.cpp \
	../src/fdk-aac/libSBRdec/src/psbitdec.cpp \
	../src/fdk-aac/libSBRdec/src/psdec.cpp \
	../src/fdk-aac/libSBRdec/src/psdec_hybrid.cpp \
	../src/fdk-aac/libSBRdec/src/sbr_crc.cpp \
	../src/fdk-aac/libSBRdec/src/sbr_deb.cpp \
	../src/fdk-aac/libSBRdec/src/sbr_dec.cpp \
	../src/fdk-aac/libSBRdec/src/sbr_ram.cpp \
	../src/fdk-aac/libSBRdec/src/sbr_rom.cpp \
	../src/fdk-aac/libSBRdec/src/sbrdec_drc.cpp \
	../src/fdk-aac/libSBRdec/src/sbrdec_freq_sca.cpp \
	../src/fdk-aac/libSBRdec/src/sbrdecoder.cpp \
	../src/fdk-aac/libPCMutils/src/limiter.cpp \
	../src/fdk-aac/libPCMutils/src/pcmutils_lib.cpp

LOCAL_CFLAGS := -O3 -ffast-math -Wno-incompatible-pointer-types -Wno-enum-conversion

LOCAL_CFLAGS += -Wno-tautological-constant-out-of-range-compare -Wno-c++11-narrowing

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
LOCAL_CFLAGS += -Wno-parentheses-equality -Wno-unsequenced

include $(BUILD_STATIC_LIBRARY)
