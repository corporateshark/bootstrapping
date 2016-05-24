LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := libmp4v2

LOCAL_ARM_MODE := arm
LOCAL_C_INCLUDES := \
    $(LOCAL_PATH)/../src/mp4v2 \
    $(LOCAL_PATH)/../src/mp4v2/include \
    $(LOCAL_PATH)/../src/mp4v2/libplatform

LOCAL_SRC_FILES  := \
	../src/mp4v2/src/3gp.cpp \
	../src/mp4v2/src/atom_ac3.cpp \
	../src/mp4v2/src/atom_amr.cpp \
	../src/mp4v2/src/atom_avc1.cpp \
	../src/mp4v2/src/atom_avcC.cpp \
	../src/mp4v2/src/atom_chpl.cpp \
	../src/mp4v2/src/atom_colr.cpp \
	../src/mp4v2/src/atom_d263.cpp \
	../src/mp4v2/src/atom_dac3.cpp \
	../src/mp4v2/src/atom_damr.cpp \
	../src/mp4v2/src/atom_dref.cpp \
	../src/mp4v2/src/atom_elst.cpp \
	../src/mp4v2/src/atom_enca.cpp \
	../src/mp4v2/src/atom_encv.cpp \
	../src/mp4v2/src/atom_free.cpp \
	../src/mp4v2/src/atom_ftab.cpp \
	../src/mp4v2/src/atom_ftyp.cpp \
	../src/mp4v2/src/atom_gmin.cpp \
	../src/mp4v2/src/atom_hdlr.cpp \
	../src/mp4v2/src/atom_hinf.cpp \
	../src/mp4v2/src/atom_hnti.cpp \
	../src/mp4v2/src/atom_href.cpp \
	../src/mp4v2/src/atom_mdat.cpp \
	../src/mp4v2/src/atom_mdhd.cpp \
	../src/mp4v2/src/atom_meta.cpp \
	../src/mp4v2/src/atom_mp4s.cpp \
	../src/mp4v2/src/atom_mp4v.cpp \
	../src/mp4v2/src/atom_mvhd.cpp \
	../src/mp4v2/src/atom_nmhd.cpp \
	../src/mp4v2/src/atom_ohdr.cpp \
	../src/mp4v2/src/atom_pasp.cpp \
	../src/mp4v2/src/atom_root.cpp \
	../src/mp4v2/src/atom_rtp.cpp \
	../src/mp4v2/src/atom_s263.cpp \
	../src/mp4v2/src/atom_sdp.cpp \
	../src/mp4v2/src/atom_sdtp.cpp \
	../src/mp4v2/src/atom_smi.cpp \
	../src/mp4v2/src/atom_sound.cpp \
	../src/mp4v2/src/atom_standard.cpp \
	../src/mp4v2/src/atom_stbl.cpp \
	../src/mp4v2/src/atom_stdp.cpp \
	../src/mp4v2/src/atom_stsc.cpp \
	../src/mp4v2/src/atom_stsd.cpp \
	../src/mp4v2/src/atom_stsz.cpp \
	../src/mp4v2/src/atom_stz2.cpp \
	../src/mp4v2/src/atom_text.cpp \
	../src/mp4v2/src/atom_tfhd.cpp \
	../src/mp4v2/src/atom_tkhd.cpp \
	../src/mp4v2/src/atom_treftype.cpp \
	../src/mp4v2/src/atom_trun.cpp \
	../src/mp4v2/src/atom_tx3g.cpp \
	../src/mp4v2/src/atom_udta.cpp \
	../src/mp4v2/src/atom_url.cpp \
	../src/mp4v2/src/atom_urn.cpp \
	../src/mp4v2/src/atom_uuid.cpp \
	../src/mp4v2/src/atom_video.cpp \
	../src/mp4v2/src/atom_vmhd.cpp \
	../src/mp4v2/src/cmeta.cpp \
	../src/mp4v2/src/descriptors.cpp \
	../src/mp4v2/src/exception.cpp \
	../src/mp4v2/src/isma.cpp \
	../src/mp4v2/src/log.cpp \
	../src/mp4v2/src/mp4.cpp \
	../src/mp4v2/src/mp4atom.cpp \
	../src/mp4v2/src/mp4container.cpp \
	../src/mp4v2/src/mp4descriptor.cpp \
	../src/mp4v2/src/mp4file.cpp \
	../src/mp4v2/src/mp4file_io.cpp \
	../src/mp4v2/src/mp4info.cpp \
	../src/mp4v2/src/mp4property.cpp \
	../src/mp4v2/src/mp4track.cpp \
	../src/mp4v2/src/mp4util.cpp \
	../src/mp4v2/src/ocidescriptors.cpp \
	../src/mp4v2/src/odcommands.cpp \
	../src/mp4v2/src/qosqualifiers.cpp \
	../src/mp4v2/src/rtphint.cpp \
	../src/mp4v2/src/text.cpp \
	../src/mp4v2/src/bmff/typebmff.cpp \
	../src/mp4v2/src/itmf/CoverArtBox.cpp \
	../src/mp4v2/src/itmf/generic.cpp \
	../src/mp4v2/src/itmf/Tags.cpp \
	../src/mp4v2/src/itmf/type.cpp \
	../src/mp4v2/src/qtff/coding.cpp \
	../src/mp4v2/src/qtff/ColorParameterBox.cpp \
	../src/mp4v2/src/qtff/PictureAspectRatioBox.cpp \
	../src/mp4v2/libutil/crc.cpp \
	../src/mp4v2/libutil/Database.cpp \
	../src/mp4v2/libutil/other.cpp \
	../src/mp4v2/libutil/Timecode.cpp \
	../src/mp4v2/libutil/TrackModifier.cpp \
	../src/mp4v2/libutil/Utility.cpp \
	../src/mp4v2/libplatform/io/File.cpp \
	../src/mp4v2/libplatform/io/FileSystem.cpp \
	../src/mp4v2/libplatform/prog/option.cpp \
	../src/mp4v2/libplatform/sys/error.cpp \
	../src/mp4v2/libplatform/time/time.cpp \
	../src/mp4v2/libplatform/io/File_posix.cpp \
	../src/mp4v2/libplatform/io/FileSystem_posix.cpp \
	../src/mp4v2/libplatform/number/random_posix.cpp \
	../src/mp4v2/libplatform/process/process_posix.cpp \
	../src/mp4v2/libplatform/time/time_posix.cpp

LOCAL_CFLAGS := -O3 -ffast-math -Wno-incompatible-pointer-types -Wno-enum-conversion -Wno-reserved-user-defined-literal -Wno-c++11-narrowing -Wno-invalid-source-encoding

LOCAL_CFLAGS += -DMP4V2_USE_STATIC_LIB

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
    LOCAL_ARM_NEON := true
    LOCAL_CFLAGS += -mfpu=neon -march=armv7-a
endif

ifeq ($(TARGET_ARCH_ABI),x86)
	LOCAL_CFLAGS += -m32 -march=i686 -mtune=atom -mssse3 -mfpmath=sse
endif

#   Suppress stupid compiler warnings
LOCAL_CFLAGS += -Wno-tautological-pointer-compare

include $(BUILD_STATIC_LIBRARY)
