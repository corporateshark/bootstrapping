LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := freetype

LOCAL_C_INCLUDES += \
    $(LOCAL_PATH)/../src/freetype/include \
    $(LOCAL_PATH)/../src/freetype/src \

LOCAL_EXPORT_C_INCLUDES += \
    $(LOCAL_PATH)/../src/freetype/include \
    $(LOCAL_PATH)/../src/freetype/src \

LOCAL_SRC_FILES := \
	../src/freetype/src/autofit/autofit.c \
	../src/freetype/src/base/basepic.c \
	../src/freetype/src/base/ftadvanc.c \
	../src/freetype/src/base/ftapi.c \
	../src/freetype/src/base/ftbase.c \
	../src/freetype/src/base/ftbbox.c \
	../src/freetype/src/base/ftbdf.c \
	../src/freetype/src/base/ftbitmap.c \
	../src/freetype/src/base/ftcalc.c \
	../src/freetype/src/base/ftcid.c \
	../src/freetype/src/base/ftdbgmem.c \
	../src/freetype/src/base/ftdebug.c \
	../src/freetype/src/base/ftfntfmt.c \
	../src/freetype/src/base/ftfstype.c \
	../src/freetype/src/base/ftgasp.c \
	../src/freetype/src/base/ftgloadr.c \
	../src/freetype/src/base/ftglyph.c \
	../src/freetype/src/base/ftgxval.c \
	../src/freetype/src/base/ftinit.c \
	../src/freetype/src/base/ftlcdfil.c \
	../src/freetype/src/base/ftmm.c \
	../src/freetype/src/base/ftobjs.c \
	../src/freetype/src/base/ftotval.c \
	../src/freetype/src/base/ftoutln.c \
	../src/freetype/src/base/ftpatent.c \
	../src/freetype/src/base/ftpfr.c \
	../src/freetype/src/base/ftpic.c \
	../src/freetype/src/base/ftrfork.c \
	../src/freetype/src/base/ftsnames.c \
	../src/freetype/src/base/ftstream.c \
	../src/freetype/src/base/ftstroke.c \
	../src/freetype/src/base/ftsynth.c \
	../src/freetype/src/base/ftsystem.c \
	../src/freetype/src/base/fttrigon.c \
	../src/freetype/src/base/fttype1.c \
	../src/freetype/src/base/ftutil.c \
	../src/freetype/src/base/ftwinfnt.c \
	../src/freetype/src/base/md5.c \
	../src/freetype/src/bdf/bdf.c \
	../src/freetype/src/bzip2/ftbzip2.c \
	../src/freetype/src/cache/ftcache.c \
	../src/freetype/src/cff/cff.c \
	../src/freetype/src/cid/type1cid.c \
	../src/freetype/src/gxvalid/gxvalid.c \
	../src/freetype/src/gzip/ftgzip.c \
	../src/freetype/src/lzw/ftlzw.c \
	../src/freetype/src/lzw/ftzopen.c \
	../src/freetype/src/otvalid/otvalid.c \
	../src/freetype/src/pcf/pcf.c \
	../src/freetype/src/pfr/pfr.c \
	../src/freetype/src/psaux/psaux.c \
	../src/freetype/src/pshinter/pshinter.c \
	../src/freetype/src/psnames/psnames.c \
	../src/freetype/src/raster/raster.c \
	../src/freetype/src/sfnt/sfnt.c \
	../src/freetype/src/smooth/smooth.c \
	../src/freetype/src/truetype/truetype.c \
	../src/freetype/src/type1/type1.c \
	../src/freetype/src/type42/type42.c \
	../src/freetype/src/winfonts/winfnt.c \

LOCAL_CFLAGS := -O2 -DFT2_BUILD_LIBRARY -DDARWIN_NO_CARBON -Wno-parentheses-equality

ifeq (,$(findstring debug, $(CONFIG)))
    LOCAL_CFLAGS += -fvisibility=hidden
endif

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
    LOCAL_ARM_NEON := true
    LOCAL_CFLAGS += -mfloat-abi=hard -mfpu=neon -march=armv7-a
endif

ifeq ($(TARGET_ARCH_ABI),x86)
	LOCAL_CFLAGS += -m32 -march=i686 -mtune=atom -mssse3 -mfpmath=sse
endif

include $(BUILD_STATIC_LIBRARY)
