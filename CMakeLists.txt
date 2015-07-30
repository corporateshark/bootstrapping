cmake_minimum_required(VERSION 2.8)

project("External")

if (NOT CMAKE_BUILD_TYPE)
	message(STATUS "No build type selected, default to Release")
	set(CMAKE_BUILD_TYPE "Release")
endif()

add_definitions(
    -DLIBDIR
    )

if(MSVC)
	add_definitions(
		-D_CRT_SECURE_NO_WARNINGS
     )
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd4456 /wd4457 /wd4458 /wd4018 /wd4068 /wd4996")
	set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /wd4456 /wd4457 /wd4458 /wd4018 /wd4068 /wd4996")
endif(MSVC)

add_library(z EXCLUDE_FROM_ALL
    src/zlib/adler32.c
    src/zlib/compress.c
    src/zlib/crc32.c
    src/zlib/deflate.c
    src/zlib/gzclose.c
    src/zlib/gzlib.c
    src/zlib/gzread.c
    src/zlib/gzwrite.c
    src/zlib/infback.c
    src/zlib/inffast.c
    src/zlib/inflate.c
    src/zlib/inftrees.c
    src/zlib/trees.c
    src/zlib/uncompr.c
    src/zlib/zutil.c
)
target_include_directories(z PUBLIC src/zlib)
if(NOT MSVC)
    set_target_properties(z PROPERTIES COMPILE_FLAGS "-Wno-implicit-function-declaration")
endif()

add_library(bz2 EXCLUDE_FROM_ALL
    src/bzip2/blocksort.c
    src/bzip2/bzlib.c
    src/bzip2/compress.c
    src/bzip2/crctable.c
    src/bzip2/decompress.c
    src/bzip2/huffman.c
    src/bzip2/randtable.c
)
target_include_directories(bz2 PUBLIC src/bzip2)

add_library(gif EXCLUDE_FROM_ALL
    src/giflib/lib/dgif_lib.c
    src/giflib/lib/gif_err.c
    src/giflib/lib/gif_font.c
    src/giflib/lib/gif_hash.c
    src/giflib/lib/gifalloc.c
    )
target_include_directories(gif PUBLIC src/giflib/lib)

add_library(png EXCLUDE_FROM_ALL
    src/libpng/png.c
    src/libpng/pngerror.c
    src/libpng/pngget.c
    src/libpng/pngmem.c
    src/libpng/pngpread.c
    src/libpng/pngread.c
    src/libpng/pngrio.c
    src/libpng/pngrtran.c
    src/libpng/pngrutil.c
    src/libpng/pngset.c
    src/libpng/pngtrans.c
    src/libpng/pngwio.c
    src/libpng/pngwrite.c
    src/libpng/pngwtran.c
    src/libpng/pngwutil.c
    )
target_include_directories(png PUBLIC src/zlib src/libpng)

add_library(jpeg EXCLUDE_FROM_ALL
    src/libjpeg/jaricom.c
    src/libjpeg/jcapimin.c
    src/libjpeg/jcapistd.c
    src/libjpeg/jcarith.c
    src/libjpeg/jccoefct.c
    src/libjpeg/jccolor.c
    src/libjpeg/jcdctmgr.c
    src/libjpeg/jchuff.c
    src/libjpeg/jcinit.c
    src/libjpeg/jcmainct.c
    src/libjpeg/jcmarker.c
    src/libjpeg/jcmaster.c
    src/libjpeg/jcomapi.c
    src/libjpeg/jcparam.c
    src/libjpeg/jcprepct.c
    src/libjpeg/jcsample.c
    src/libjpeg/jctrans.c
    src/libjpeg/jdapimin.c
    src/libjpeg/jdapistd.c
    src/libjpeg/jdarith.c
    src/libjpeg/jdatadst.c
    src/libjpeg/jdatasrc.c
    src/libjpeg/jdcoefct.c
    src/libjpeg/jdcolor.c
    src/libjpeg/jddctmgr.c
    src/libjpeg/jdhuff.c
    src/libjpeg/jdinput.c
    src/libjpeg/jdmainct.c
    src/libjpeg/jdmarker.c
    src/libjpeg/jdmaster.c
    src/libjpeg/jdmerge.c
    src/libjpeg/jdpostct.c
    src/libjpeg/jdsample.c
    src/libjpeg/jdtrans.c
    src/libjpeg/jerror.c
    src/libjpeg/jfdctflt.c
    src/libjpeg/jfdctfst.c
    src/libjpeg/jfdctint.c
    src/libjpeg/jidctflt.c
    src/libjpeg/jidctfst.c
    src/libjpeg/jidctint.c
    src/libjpeg/jmemnobs.c
    src/libjpeg/jmemmgr.c
    src/libjpeg/jquant1.c
    src/libjpeg/jquant2.c
    src/libjpeg/jutils.c
    )
target_include_directories(jpeg PUBLIC src/libjpeg)

add_library(zxing EXCLUDE_FROM_ALL
    src/zxing-cpp/core/src/zxing/oned/CodaBarReader.cpp
    src/zxing-cpp/core/src/zxing/oned/Code128Reader.cpp
    src/zxing-cpp/core/src/zxing/oned/Code39Reader.cpp
    src/zxing-cpp/core/src/zxing/oned/Code93Reader.cpp
    src/zxing-cpp/core/src/zxing/oned/EAN13Reader.cpp
    src/zxing-cpp/core/src/zxing/oned/EAN8Reader.cpp
    src/zxing-cpp/core/src/zxing/oned/ITFReader.cpp
    src/zxing-cpp/core/src/zxing/oned/MultiFormatOneDReader.cpp
    src/zxing-cpp/core/src/zxing/oned/MultiFormatUPCEANReader.cpp
    src/zxing-cpp/core/src/zxing/oned/OneDReader.cpp
    src/zxing-cpp/core/src/zxing/oned/OneDResultPoint.cpp
    src/zxing-cpp/core/src/zxing/oned/UPCAReader.cpp
    src/zxing-cpp/core/src/zxing/oned/UPCEANReader.cpp
    src/zxing-cpp/core/src/zxing/oned/UPCEReader.cpp
    src/zxing-cpp/core/src/zxing/datamatrix/DataMatrixReader.cpp
    src/zxing-cpp/core/src/zxing/datamatrix/Version.cpp
    src/zxing-cpp/core/src/zxing/datamatrix/decoder/BitMatrixParser.cpp
    src/zxing-cpp/core/src/zxing/datamatrix/decoder/DataBlock.cpp
    src/zxing-cpp/core/src/zxing/datamatrix/decoder/DecodedBitStreamParser.cpp
    src/zxing-cpp/core/src/zxing/datamatrix/decoder/Decoder.cpp
    src/zxing-cpp/core/src/zxing/datamatrix/detector/CornerPoint.cpp
    src/zxing-cpp/core/src/zxing/datamatrix/detector/Detector.cpp
    src/zxing-cpp/core/src/zxing/datamatrix/detector/DetectorException.cpp
    src/zxing-cpp/core/src/zxing/common/BitArray.cpp
    src/zxing-cpp/core/src/zxing/common/BitArrayIO.cpp
    src/zxing-cpp/core/src/zxing/common/BitMatrix.cpp
    src/zxing-cpp/core/src/zxing/common/BitSource.cpp
    src/zxing-cpp/core/src/zxing/common/CharacterSetECI.cpp
    src/zxing-cpp/core/src/zxing/common/DecoderResult.cpp
    src/zxing-cpp/core/src/zxing/common/DetectorResult.cpp
    src/zxing-cpp/core/src/zxing/common/GlobalHistogramBinarizer.cpp
    src/zxing-cpp/core/src/zxing/common/GreyscaleLuminanceSource.cpp
    src/zxing-cpp/core/src/zxing/common/GreyscaleRotatedLuminanceSource.cpp
    src/zxing-cpp/core/src/zxing/common/GridSampler.cpp
    src/zxing-cpp/core/src/zxing/common/HybridBinarizer.cpp
    src/zxing-cpp/core/src/zxing/common/IllegalArgumentException.cpp
    src/zxing-cpp/core/src/zxing/common/PerspectiveTransform.cpp
    src/zxing-cpp/core/src/zxing/common/Str.cpp
    src/zxing-cpp/core/src/zxing/common/StringUtils.cpp
    src/zxing-cpp/core/src/zxing/common/reedsolomon/GenericGF.cpp
    src/zxing-cpp/core/src/zxing/common/reedsolomon/GenericGFPoly.cpp
    src/zxing-cpp/core/src/zxing/common/reedsolomon/ReedSolomonDecoder.cpp
    src/zxing-cpp/core/src/zxing/common/reedsolomon/ReedSolomonException.cpp
    src/zxing-cpp/core/src/zxing/common/detector/MonochromeRectangleDetector.cpp
    src/zxing-cpp/core/src/zxing/common/detector/WhiteRectangleDetector.cpp
    src/zxing-cpp/core/src/zxing/qrcode/ErrorCorrectionLevel.cpp
    src/zxing-cpp/core/src/zxing/qrcode/FormatInformation.cpp
    src/zxing-cpp/core/src/zxing/qrcode/QRCodeReader.cpp
    src/zxing-cpp/core/src/zxing/qrcode/Version.cpp
    src/zxing-cpp/core/src/zxing/qrcode/decoder/BitMatrixParser.cpp
    src/zxing-cpp/core/src/zxing/qrcode/decoder/DataBlock.cpp
    src/zxing-cpp/core/src/zxing/qrcode/decoder/DataMask.cpp
    src/zxing-cpp/core/src/zxing/qrcode/decoder/DecodedBitStreamParser.cpp
    src/zxing-cpp/core/src/zxing/qrcode/decoder/Decoder.cpp
    src/zxing-cpp/core/src/zxing/qrcode/decoder/Mode.cpp
    src/zxing-cpp/core/src/zxing/qrcode/detector/AlignmentPattern.cpp
    src/zxing-cpp/core/src/zxing/qrcode/detector/AlignmentPatternFinder.cpp
    src/zxing-cpp/core/src/zxing/qrcode/detector/Detector.cpp
    src/zxing-cpp/core/src/zxing/qrcode/detector/FinderPattern.cpp
    src/zxing-cpp/core/src/zxing/qrcode/detector/FinderPatternFinder.cpp
    src/zxing-cpp/core/src/zxing/qrcode/detector/FinderPatternInfo.cpp
    src/zxing-cpp/core/src/zxing/aztec/AztecDetectorResult.cpp
    src/zxing-cpp/core/src/zxing/aztec/AztecReader.cpp
    src/zxing-cpp/core/src/zxing/aztec/decoder/Decoder.cpp
    src/zxing-cpp/core/src/zxing/aztec/detector/Detector.cpp
    src/zxing-cpp/core/src/zxing/pdf417/PDF417Reader.cpp
    src/zxing-cpp/core/src/zxing/pdf417/detector/Detector.cpp
    src/zxing-cpp/core/src/zxing/pdf417/detector/LinesSampler.cpp
    src/zxing-cpp/core/src/zxing/pdf417/decoder/BitMatrixParser.cpp
    src/zxing-cpp/core/src/zxing/pdf417/decoder/DecodedBitStreamParser.cpp
    src/zxing-cpp/core/src/zxing/pdf417/decoder/Decoder.cpp
    src/zxing-cpp/core/src/zxing/pdf417/decoder/ec/ErrorCorrection.cpp
    src/zxing-cpp/core/src/zxing/pdf417/decoder/ec/ModulusGF.cpp
    src/zxing-cpp/core/src/zxing/pdf417/decoder/ec/ModulusPoly.cpp
    src/zxing-cpp/core/src/zxing/multi/ByQuadrantReader.cpp
    src/zxing-cpp/core/src/zxing/multi/GenericMultipleBarcodeReader.cpp
    src/zxing-cpp/core/src/zxing/multi/MultipleBarcodeReader.cpp
    src/zxing-cpp/core/src/zxing/BarcodeFormat.cpp
    src/zxing-cpp/core/src/zxing/Binarizer.cpp
    src/zxing-cpp/core/src/zxing/BinaryBitmap.cpp
    src/zxing-cpp/core/src/zxing/ChecksumException.cpp
    src/zxing-cpp/core/src/zxing/DecodeHints.cpp
    src/zxing-cpp/core/src/zxing/Exception.cpp
    src/zxing-cpp/core/src/zxing/FormatException.cpp
    src/zxing-cpp/core/src/zxing/InvertedLuminanceSource.cpp
    src/zxing-cpp/core/src/zxing/LuminanceSource.cpp
    src/zxing-cpp/core/src/zxing/MultiFormatReader.cpp
    src/zxing-cpp/core/src/zxing/Reader.cpp
    src/zxing-cpp/core/src/zxing/Result.cpp
    src/zxing-cpp/core/src/zxing/ResultIO.cpp
    src/zxing-cpp/core/src/zxing/ResultPoint.cpp
    src/zxing-cpp/core/src/zxing/ResultPointCallback.cpp
    src/zxing-cpp/core/src/bigint/BigInteger.cc
    src/zxing-cpp/core/src/bigint/BigIntegerAlgorithms.cc
    src/zxing-cpp/core/src/bigint/BigIntegerUtils.cc
    src/zxing-cpp/core/src/bigint/BigUnsigned.cc
    src/zxing-cpp/core/src/bigint/BigUnsignedInABase.cc
    )
target_include_directories(zxing PUBLIC src/zxing-cpp/core/src PRIVATE src src/libiconv/include src/boost)

add_library(AGAST EXCLUDE_FROM_ALL
    src/AGAST/agast5_8.cc
    src/AGAST/agast5_8_nms.cc
    src/AGAST/agast7_12d.cc
    src/AGAST/agast7_12d_nms.cc
    src/AGAST/agast7_12s.cc
    src/AGAST/agast7_12s_nms.cc
    src/AGAST/nonMaximumSuppression.cc
    src/AGAST/oast9_16.cc
    src/AGAST/oast9_16_nms.cc
    )
target_include_directories(AGAST PUBLIC src)

add_library(FAST EXCLUDE_FROM_ALL
    src/FAST/fast_9_MH.cpp
    src/FAST/nonmax_MH.cpp
    )
target_include_directories(FAST PUBLIC src)

add_library(iconv EXCLUDE_FROM_ALL
    src/libiconv/lib/iconv.c
    src/libiconv/lib/relocatable.c
    src/libiconv/libcharset/lib/localcharset.c
    )
target_include_directories(iconv PUBLIC
    src/libiconv
    src/libiconv/include
    src/libiconv/lib
    src/libiconv/srclib
    )

if (ANDROID_MK)
    android_mk_create()
    android_mk_static_library(gif CFLAGS "\$(EXTERNAL_CFLAGS)")
    android_mk_static_library(png CFLAGS "\$(EXTERNAL_CFLAGS)")
    android_mk_static_library(jpeg CFLAGS "\$(EXTERNAL_CFLAGS)")
    android_mk_static_library(zxing CFLAGS "\$(EXTERNAL_CFLAGS)" SHARED_LIBRARIES iconv)
    android_mk_static_library(AGAST CFLAGS "\$(EXTERNAL_CFLAGS)")
    android_mk_static_library(FAST CFLAGS "\$(EXTERNAL_CFLAGS)")
    android_mk_shared_library(iconv CFLAGS "\$(EXTERNAL_CFLAGS) -DLIBDIR")
endif()
