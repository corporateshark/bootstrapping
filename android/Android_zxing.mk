LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := zxing

LOCAL_C_INCLUDES := \
    $(LOCAL_PATH)/../src/zxing-cpp/core/src \

LOCAL_SRC_FILES := \
    ../src/zxing-cpp/core/src/zxing/oned/CodaBarReader.cpp \
    ../src/zxing-cpp/core/src/zxing/oned/Code128Reader.cpp \
    ../src/zxing-cpp/core/src/zxing/oned/Code39Reader.cpp \
    ../src/zxing-cpp/core/src/zxing/oned/Code93Reader.cpp \
    ../src/zxing-cpp/core/src/zxing/oned/EAN13Reader.cpp \
    ../src/zxing-cpp/core/src/zxing/oned/EAN8Reader.cpp \
    ../src/zxing-cpp/core/src/zxing/oned/ITFReader.cpp \
    ../src/zxing-cpp/core/src/zxing/oned/MultiFormatOneDReader.cpp \
    ../src/zxing-cpp/core/src/zxing/oned/MultiFormatUPCEANReader.cpp \
    ../src/zxing-cpp/core/src/zxing/oned/OneDReader.cpp \
    ../src/zxing-cpp/core/src/zxing/oned/OneDResultPoint.cpp \
    ../src/zxing-cpp/core/src/zxing/oned/UPCAReader.cpp \
    ../src/zxing-cpp/core/src/zxing/oned/UPCEANReader.cpp \
    ../src/zxing-cpp/core/src/zxing/oned/UPCEReader.cpp \
    ../src/zxing-cpp/core/src/zxing/datamatrix/DataMatrixReader.cpp \
    ../src/zxing-cpp/core/src/zxing/datamatrix/Version.cpp \
    ../src/zxing-cpp/core/src/zxing/datamatrix/decoder/BitMatrixParser.cpp \
    ../src/zxing-cpp/core/src/zxing/datamatrix/decoder/DataBlock.cpp \
    ../src/zxing-cpp/core/src/zxing/datamatrix/decoder/DecodedBitStreamParser.cpp \
    ../src/zxing-cpp/core/src/zxing/datamatrix/decoder/Decoder.cpp \
    ../src/zxing-cpp/core/src/zxing/datamatrix/detector/CornerPoint.cpp \
    ../src/zxing-cpp/core/src/zxing/datamatrix/detector/Detector.cpp \
    ../src/zxing-cpp/core/src/zxing/datamatrix/detector/DetectorException.cpp \
    ../src/zxing-cpp/core/src/zxing/common/BitArray.cpp \
    ../src/zxing-cpp/core/src/zxing/common/BitArrayIO.cpp \
    ../src/zxing-cpp/core/src/zxing/common/BitMatrix.cpp \
    ../src/zxing-cpp/core/src/zxing/common/BitSource.cpp \
    ../src/zxing-cpp/core/src/zxing/common/CharacterSetECI.cpp \
    ../src/zxing-cpp/core/src/zxing/common/DecoderResult.cpp \
    ../src/zxing-cpp/core/src/zxing/common/DetectorResult.cpp \
    ../src/zxing-cpp/core/src/zxing/common/GlobalHistogramBinarizer.cpp \
    ../src/zxing-cpp/core/src/zxing/common/GreyscaleLuminanceSource.cpp \
    ../src/zxing-cpp/core/src/zxing/common/GreyscaleRotatedLuminanceSource.cpp \
    ../src/zxing-cpp/core/src/zxing/common/GridSampler.cpp \
    ../src/zxing-cpp/core/src/zxing/common/HybridBinarizer.cpp \
    ../src/zxing-cpp/core/src/zxing/common/IllegalArgumentException.cpp \
    ../src/zxing-cpp/core/src/zxing/common/PerspectiveTransform.cpp \
    ../src/zxing-cpp/core/src/zxing/common/Str.cpp \
    ../src/zxing-cpp/core/src/zxing/common/StringUtils.cpp \
    ../src/zxing-cpp/core/src/zxing/common/reedsolomon/GenericGF.cpp \
    ../src/zxing-cpp/core/src/zxing/common/reedsolomon/GenericGFPoly.cpp \
    ../src/zxing-cpp/core/src/zxing/common/reedsolomon/ReedSolomonDecoder.cpp \
    ../src/zxing-cpp/core/src/zxing/common/reedsolomon/ReedSolomonException.cpp \
    ../src/zxing-cpp/core/src/zxing/common/detector/MonochromeRectangleDetector.cpp \
    ../src/zxing-cpp/core/src/zxing/common/detector/WhiteRectangleDetector.cpp \
    ../src/zxing-cpp/core/src/zxing/qrcode/ErrorCorrectionLevel.cpp \
    ../src/zxing-cpp/core/src/zxing/qrcode/FormatInformation.cpp \
    ../src/zxing-cpp/core/src/zxing/qrcode/QRCodeReader.cpp \
    ../src/zxing-cpp/core/src/zxing/qrcode/Version.cpp \
    ../src/zxing-cpp/core/src/zxing/qrcode/decoder/BitMatrixParser.cpp \
    ../src/zxing-cpp/core/src/zxing/qrcode/decoder/DataBlock.cpp \
    ../src/zxing-cpp/core/src/zxing/qrcode/decoder/DataMask.cpp \
    ../src/zxing-cpp/core/src/zxing/qrcode/decoder/DecodedBitStreamParser.cpp \
    ../src/zxing-cpp/core/src/zxing/qrcode/decoder/Decoder.cpp \
    ../src/zxing-cpp/core/src/zxing/qrcode/decoder/Mode.cpp \
    ../src/zxing-cpp/core/src/zxing/qrcode/detector/AlignmentPattern.cpp \
    ../src/zxing-cpp/core/src/zxing/qrcode/detector/AlignmentPatternFinder.cpp \
    ../src/zxing-cpp/core/src/zxing/qrcode/detector/Detector.cpp \
    ../src/zxing-cpp/core/src/zxing/qrcode/detector/FinderPattern.cpp \
    ../src/zxing-cpp/core/src/zxing/qrcode/detector/FinderPatternFinder.cpp \
    ../src/zxing-cpp/core/src/zxing/qrcode/detector/FinderPatternInfo.cpp \
    ../src/zxing-cpp/core/src/zxing/aztec/AztecDetectorResult.cpp \
    ../src/zxing-cpp/core/src/zxing/aztec/AztecReader.cpp \
    ../src/zxing-cpp/core/src/zxing/aztec/decoder/Decoder.cpp \
    ../src/zxing-cpp/core/src/zxing/aztec/detector/Detector.cpp \
    ../src/zxing-cpp/core/src/zxing/pdf417/PDF417Reader.cpp \
    ../src/zxing-cpp/core/src/zxing/pdf417/detector/Detector.cpp \
    ../src/zxing-cpp/core/src/zxing/pdf417/detector/LinesSampler.cpp \
    ../src/zxing-cpp/core/src/zxing/pdf417/decoder/BitMatrixParser.cpp \
    ../src/zxing-cpp/core/src/zxing/pdf417/decoder/DecodedBitStreamParser.cpp \
    ../src/zxing-cpp/core/src/zxing/pdf417/decoder/Decoder.cpp \
    ../src/zxing-cpp/core/src/zxing/pdf417/decoder/ec/ErrorCorrection.cpp \
    ../src/zxing-cpp/core/src/zxing/pdf417/decoder/ec/ModulusGF.cpp \
    ../src/zxing-cpp/core/src/zxing/pdf417/decoder/ec/ModulusPoly.cpp \
    ../src/zxing-cpp/core/src/zxing/multi/ByQuadrantReader.cpp \
    ../src/zxing-cpp/core/src/zxing/multi/GenericMultipleBarcodeReader.cpp \
    ../src/zxing-cpp/core/src/zxing/multi/MultipleBarcodeReader.cpp \
    ../src/zxing-cpp/core/src/zxing/BarcodeFormat.cpp \
    ../src/zxing-cpp/core/src/zxing/Binarizer.cpp \
    ../src/zxing-cpp/core/src/zxing/BinaryBitmap.cpp \
    ../src/zxing-cpp/core/src/zxing/ChecksumException.cpp \
    ../src/zxing-cpp/core/src/zxing/DecodeHints.cpp \
    ../src/zxing-cpp/core/src/zxing/Exception.cpp \
    ../src/zxing-cpp/core/src/zxing/FormatException.cpp \
    ../src/zxing-cpp/core/src/zxing/InvertedLuminanceSource.cpp \
    ../src/zxing-cpp/core/src/zxing/LuminanceSource.cpp \
    ../src/zxing-cpp/core/src/zxing/MultiFormatReader.cpp \
    ../src/zxing-cpp/core/src/zxing/Reader.cpp \
    ../src/zxing-cpp/core/src/zxing/Result.cpp \
    ../src/zxing-cpp/core/src/zxing/ResultIO.cpp \
    ../src/zxing-cpp/core/src/zxing/ResultPoint.cpp \
    ../src/zxing-cpp/core/src/zxing/ResultPointCallback.cpp \
    ../src/zxing-cpp/core/src/bigint/BigInteger.cc \
    ../src/zxing-cpp/core/src/bigint/BigIntegerAlgorithms.cc \
    ../src/zxing-cpp/core/src/bigint/BigIntegerUtils.cc \
    ../src/zxing-cpp/core/src/bigint/BigUnsigned.cc \
    ../src/zxing-cpp/core/src/bigint/BigUnsignedInABase.cc \
    

LOCAL_CFLAGS :=
LOCAL_CPPFLAGS :=

ifeq (,$(findstring debug, $(CONFIG)))
    LOCAL_CFLAGS += -fvisibility=hidden
endif

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
    LOCAL_ARM_NEON := true
    #LOCAL_CFLAGS += -mfloat-abi=hard
    LOCAL_CFLAGS += -mfpu=neon -march=armv7-a
endif

ifeq ($(TARGET_ARCH_ABI),x86)
	LOCAL_CFLAGS += -m32 -march=i686 -mtune=atom -mssse3 -mfpmath=sse
endif

#   Allow building for 64 bit; avoids nuclear option LOCAL_CFLAGS += -DNO_ICONV)
ifneq (,$(findstring 64, $(TARGET_ARCH_ABI)))
    LOCAL_C_INCLUDES += \
        $(LOCAL_PATH)/../src/libiconv/include
endif

#   Suppress stupid compiler warnings
ifneq (,$(findstring 64, $(TARGET_ARCH_ABI)))
    LOCAL_CFLAGS += -Wno-absolute-value
endif

include $(BUILD_STATIC_LIBRARY)
