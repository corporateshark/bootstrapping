cmake_minimum_required(VERSION 2.8)
project(zxing)

include(../../msvc.cmake)

set(SRCDIR ${CMAKE_CURRENT_SOURCE_DIR}/../../src)
set(LIBDIR ${SRCDIR}/zxing-cpp)

add_library(zxing EXCLUDE_FROM_ALL
        ${LIBDIR}/core/src/zxing/oned/CodaBarReader.cpp
        ${LIBDIR}/core/src/zxing/oned/Code128Reader.cpp
        ${LIBDIR}/core/src/zxing/oned/Code39Reader.cpp
        ${LIBDIR}/core/src/zxing/oned/Code93Reader.cpp
        ${LIBDIR}/core/src/zxing/oned/EAN13Reader.cpp
        ${LIBDIR}/core/src/zxing/oned/EAN8Reader.cpp
        ${LIBDIR}/core/src/zxing/oned/ITFReader.cpp
        ${LIBDIR}/core/src/zxing/oned/MultiFormatOneDReader.cpp
        ${LIBDIR}/core/src/zxing/oned/MultiFormatUPCEANReader.cpp
        ${LIBDIR}/core/src/zxing/oned/OneDReader.cpp
        ${LIBDIR}/core/src/zxing/oned/OneDResultPoint.cpp
        ${LIBDIR}/core/src/zxing/oned/UPCAReader.cpp
        ${LIBDIR}/core/src/zxing/oned/UPCEANReader.cpp
        ${LIBDIR}/core/src/zxing/oned/UPCEReader.cpp
        ${LIBDIR}/core/src/zxing/datamatrix/DataMatrixReader.cpp
        ${LIBDIR}/core/src/zxing/datamatrix/Version.cpp
        ${LIBDIR}/core/src/zxing/datamatrix/decoder/BitMatrixParser.cpp
        ${LIBDIR}/core/src/zxing/datamatrix/decoder/DataBlock.cpp
        ${LIBDIR}/core/src/zxing/datamatrix/decoder/DecodedBitStreamParser.cpp
        ${LIBDIR}/core/src/zxing/datamatrix/decoder/Decoder.cpp
        ${LIBDIR}/core/src/zxing/datamatrix/detector/CornerPoint.cpp
        ${LIBDIR}/core/src/zxing/datamatrix/detector/Detector.cpp
        ${LIBDIR}/core/src/zxing/datamatrix/detector/DetectorException.cpp
        ${LIBDIR}/core/src/zxing/common/BitArray.cpp
        ${LIBDIR}/core/src/zxing/common/BitArrayIO.cpp
        ${LIBDIR}/core/src/zxing/common/BitMatrix.cpp
        ${LIBDIR}/core/src/zxing/common/BitSource.cpp
        ${LIBDIR}/core/src/zxing/common/CharacterSetECI.cpp
        ${LIBDIR}/core/src/zxing/common/DecoderResult.cpp
        ${LIBDIR}/core/src/zxing/common/DetectorResult.cpp
        ${LIBDIR}/core/src/zxing/common/GlobalHistogramBinarizer.cpp
        ${LIBDIR}/core/src/zxing/common/GreyscaleLuminanceSource.cpp
        ${LIBDIR}/core/src/zxing/common/GreyscaleRotatedLuminanceSource.cpp
        ${LIBDIR}/core/src/zxing/common/GridSampler.cpp
        ${LIBDIR}/core/src/zxing/common/HybridBinarizer.cpp
        ${LIBDIR}/core/src/zxing/common/IllegalArgumentException.cpp
        ${LIBDIR}/core/src/zxing/common/PerspectiveTransform.cpp
        ${LIBDIR}/core/src/zxing/common/Str.cpp
        ${LIBDIR}/core/src/zxing/common/StringUtils.cpp
        ${LIBDIR}/core/src/zxing/common/reedsolomon/GenericGF.cpp
        ${LIBDIR}/core/src/zxing/common/reedsolomon/GenericGFPoly.cpp
        ${LIBDIR}/core/src/zxing/common/reedsolomon/ReedSolomonDecoder.cpp
        ${LIBDIR}/core/src/zxing/common/reedsolomon/ReedSolomonException.cpp
        ${LIBDIR}/core/src/zxing/common/detector/MonochromeRectangleDetector.cpp
        ${LIBDIR}/core/src/zxing/common/detector/WhiteRectangleDetector.cpp
        ${LIBDIR}/core/src/zxing/qrcode/ErrorCorrectionLevel.cpp
        ${LIBDIR}/core/src/zxing/qrcode/FormatInformation.cpp
        ${LIBDIR}/core/src/zxing/qrcode/QRCodeReader.cpp
        ${LIBDIR}/core/src/zxing/qrcode/Version.cpp
        ${LIBDIR}/core/src/zxing/qrcode/decoder/BitMatrixParser.cpp
        ${LIBDIR}/core/src/zxing/qrcode/decoder/DataBlock.cpp
        ${LIBDIR}/core/src/zxing/qrcode/decoder/DataMask.cpp
        ${LIBDIR}/core/src/zxing/qrcode/decoder/DecodedBitStreamParser.cpp
        ${LIBDIR}/core/src/zxing/qrcode/decoder/Decoder.cpp
        ${LIBDIR}/core/src/zxing/qrcode/decoder/Mode.cpp
        ${LIBDIR}/core/src/zxing/qrcode/detector/AlignmentPattern.cpp
        ${LIBDIR}/core/src/zxing/qrcode/detector/AlignmentPatternFinder.cpp
        ${LIBDIR}/core/src/zxing/qrcode/detector/Detector.cpp
        ${LIBDIR}/core/src/zxing/qrcode/detector/FinderPattern.cpp
        ${LIBDIR}/core/src/zxing/qrcode/detector/FinderPatternFinder.cpp
        ${LIBDIR}/core/src/zxing/qrcode/detector/FinderPatternInfo.cpp
        ${LIBDIR}/core/src/zxing/aztec/AztecDetectorResult.cpp
        ${LIBDIR}/core/src/zxing/aztec/AztecReader.cpp
        ${LIBDIR}/core/src/zxing/aztec/decoder/Decoder.cpp
        ${LIBDIR}/core/src/zxing/aztec/detector/Detector.cpp
        ${LIBDIR}/core/src/zxing/pdf417/PDF417Reader.cpp
        ${LIBDIR}/core/src/zxing/pdf417/detector/Detector.cpp
        ${LIBDIR}/core/src/zxing/pdf417/detector/LinesSampler.cpp
        ${LIBDIR}/core/src/zxing/pdf417/decoder/BitMatrixParser.cpp
        ${LIBDIR}/core/src/zxing/pdf417/decoder/DecodedBitStreamParser.cpp
        ${LIBDIR}/core/src/zxing/pdf417/decoder/Decoder.cpp
        ${LIBDIR}/core/src/zxing/pdf417/decoder/ec/ErrorCorrection.cpp
        ${LIBDIR}/core/src/zxing/pdf417/decoder/ec/ModulusGF.cpp
        ${LIBDIR}/core/src/zxing/pdf417/decoder/ec/ModulusPoly.cpp
        ${LIBDIR}/core/src/zxing/multi/ByQuadrantReader.cpp
        ${LIBDIR}/core/src/zxing/multi/GenericMultipleBarcodeReader.cpp
        ${LIBDIR}/core/src/zxing/multi/MultipleBarcodeReader.cpp
        ${LIBDIR}/core/src/zxing/BarcodeFormat.cpp
        ${LIBDIR}/core/src/zxing/Binarizer.cpp
        ${LIBDIR}/core/src/zxing/BinaryBitmap.cpp
        ${LIBDIR}/core/src/zxing/ChecksumException.cpp
        ${LIBDIR}/core/src/zxing/DecodeHints.cpp
        ${LIBDIR}/core/src/zxing/Exception.cpp
        ${LIBDIR}/core/src/zxing/FormatException.cpp
        ${LIBDIR}/core/src/zxing/InvertedLuminanceSource.cpp
        ${LIBDIR}/core/src/zxing/LuminanceSource.cpp
        ${LIBDIR}/core/src/zxing/MultiFormatReader.cpp
        ${LIBDIR}/core/src/zxing/Reader.cpp
        ${LIBDIR}/core/src/zxing/Result.cpp
        ${LIBDIR}/core/src/zxing/ResultIO.cpp
        ${LIBDIR}/core/src/zxing/ResultPoint.cpp
        ${LIBDIR}/core/src/zxing/ResultPointCallback.cpp
        ${LIBDIR}/core/src/bigint/BigInteger.cc
        ${LIBDIR}/core/src/bigint/BigIntegerAlgorithms.cc
        ${LIBDIR}/core/src/bigint/BigIntegerUtils.cc
        ${LIBDIR}/core/src/bigint/BigUnsigned.cc
        ${LIBDIR}/core/src/bigint/BigUnsignedInABase.cc
)
target_include_directories(zxing PUBLIC ${LIBDIR}/core/src PRIVATE ${SRCDIR} ${SRCDIR}/libiconv/include ${SRCDIR}/boost)

if(NOT MSVC)
    set_target_properties(zxing PROPERTIES COMPILE_FLAGS "-Wno-absolute-value")
endif()