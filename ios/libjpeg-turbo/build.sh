if [ $# -eq 0 ]
  then
    echo "ERROR: need to give output directory as first argument"
    exit 0
fi

# get some absolute paths
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OUTPUTDIR="$( cd "$( dirname "$1" )" && pwd )"
EXTSRCDIR=$DIR/../../src
SRCDIR=$EXTSRCDIR/libjpeg-turbo

# add gas-preprocessor to PATH
PATH=$EXTSRCDIR/gas-preprocessor:$PATH

# some useful variables
IOS_PLATFORMDIR=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform
IOS_SYSROOT=$IOS_PLATFORMDIR/Developer/SDKs/iPhoneOS.sdk
IOS_GCC=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang
IPHONEOSVERSION="-miphoneos-version-min=5.1"

# call autoreconf in source dir
cd $SRCDIR
autoreconf -fiv configure.ac

CPUS=$(sysctl -n hw.logicalcpu_max)

# build for ARMv7

ARCH="armv7"
BUILDDIR=$OUTPUTDIR/build_$ARCH
INSTALLDIR=$OUTPUTDIR/install_$ARCH
IOS_CFLAGS="-arch $ARCH $IPHONEOSVERSION"

mkdir -p $BUILDDIR && cd $BUILDDIR

$SRCDIR/configure --prefix=$INSTALLDIR --host arm-apple-darwin10 \
  CC="$IOS_GCC" LD="$IOS_GCC" \
  CFLAGS="-mfloat-abi=softfp -isysroot $IOS_SYSROOT -O3 $IOS_CFLAGS" \
  LDFLAGS="-mfloat-abi=softfp -isysroot $IOS_SYSROOT $IOS_CFLAGS" \
  CCASFLAGS="-no-integrated-as $IOS_CFLAGS"

make -j$CPUS
make install

# build for ARMv7s

ARCH="armv7s"
BUILDDIR=$OUTPUTDIR/build_$ARCH
INSTALLDIR=$OUTPUTDIR/install_$ARCH
IOS_CFLAGS="-arch $ARCH $IPHONEOSVERSION"

mkdir -p $BUILDDIR && cd $BUILDDIR

$SRCDIR/configure --prefix=$INSTALLDIR --host arm-apple-darwin10 \
  CC="$IOS_GCC" LD="$IOS_GCC" \
  CFLAGS="-mfloat-abi=softfp -isysroot $IOS_SYSROOT -O3 $IOS_CFLAGS" \
  LDFLAGS="-mfloat-abi=softfp -isysroot $IOS_SYSROOT $IOS_CFLAGS" \
  CCASFLAGS="-no-integrated-as $IOS_CFLAGS"

make -j$CPUS
make install

# build for ARMv8

ARCH="arm64"
BUILDDIR=$OUTPUTDIR/build_$ARCH
INSTALLDIR=$OUTPUTDIR/install_$ARCH
IOS_CFLAGS="-arch $ARCH $IPHONEOSVERSION"

mkdir -p $BUILDDIR && cd $BUILDDIR

$SRCDIR/configure --prefix=$INSTALLDIR --host aarch64-apple-darwin \
  CC="$IOS_GCC" LD="$IOS_GCC" \
  CFLAGS="-isysroot $IOS_SYSROOT -O3 $IOS_CFLAGS" \
  LDFLAGS="-isysroot $IOS_SYSROOT $IOS_CFLAGS"

make -j$CPUS
make install