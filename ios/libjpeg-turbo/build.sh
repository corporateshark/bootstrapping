####### Common Configuration

if ! [ $# -eq 8 ]
then
echo "Usage: build.sh <build_directory> <install_directory> <action> <product_name> <debug/release> <ios_deployment_target> <iPhoneOS/iPhoneSimulator> <header_dir>"
exit 1
fi

if [ -z "$1" ]; then
echo "ERROR: Build Directory is not valid."
exit 1
fi

if [ -z "$2" ]; then
echo "ERROR: Install Directory is not valid."
exit 1
fi

#Create build directory if not exists
[ -d "$1" ] || mkdir -p "$1"

#Create install directory if not exists
[ -d "$2" ] || mkdir -p "$2"

# get some absolute paths
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILDDIR="$( cd "$1" && pwd )"
INSTALLDIR="$( cd "$2" && pwd )"
EXTSRCDIR="$DIR/../../src"
SRCDIR="$EXTSRCDIR/libjpeg-turbo"
ACTION="$3"
PRODUCT_NAME="$4"
CONFIGURATION="$5"
IPHONEOS_DEPLOYMENT_TARGET="$6"
PLATFORM="$7"
HEADER_DIR="$8"

echo "BUILDDIR=$BUILDDIR"
echo "INSTALLDIR=$INSTALLDIR"
echo "SRCDIR=$SRCDIR"
echo "ACTION=$ACTION"
echo "PRODUCT_NAME=$PRODUCT_NAME"
echo "CONFIGURATION=$CONFIGURATION"
echo "IPHONEOS_DEPLOYMENT_TARGET=$IPHONEOS_DEPLOYMENT_TARGET"
echo "PLATFORM=$PLATFORM"
echo "HEADER_DIR=$HEADER_DIR"

glibtoolize --version >/dev/null 2>&1 || { echo "error: glibtoolize is required but it's not installed.  Aborting." >&2; exit 1; }
automake --version >/dev/null 2>&1 || { echo "error: automake is required but it's not installed.  Aborting." >&2; exit 1; }
autoconf --version >/dev/null 2>&1 || { echo "error: autoconf is required but it's not installed.  Aborting." >&2; exit 1; }

if [ "$ACTION" == "build" ] || [ "$ACTION" == "install" ];
then
	if [ -f "$INSTALLDIR/$PRODUCT_NAME.a" ];
	then

    echo "Not building since file already exists at $INSTALLDIR/$PRODUCT_NAME.a. Please clean to rebuild"

	lipo -info "$INSTALLDIR/$PRODUCT_NAME.a"

    exit 0

    fi
fi

# some useful variables

IOS_PLATFORMDIR=/Applications/Xcode.app/Contents/Developer/Platforms/$PLATFORM.platform

IOS_SYSROOT=$IOS_PLATFORMDIR/Developer/SDKs/$PLATFORM.sdk

DEVROOT=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain

IOS_GCC=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang

IPHONEOSVERSION="-miphoneos-version-min=$IPHONEOS_DEPLOYMENT_TARGET"

CPUS=$(sysctl -n hw.logicalcpu_max)

if [ "$CONFIGURATION" == "Debug" ];
then
OPTIMIZATION_LEVEL="-O1"
else
OPTIMIZATION_LEVEL="-O3"
fi

function clean()
{
  ARCH=$1
  echo "Cleaning...$ARCH"

  if [ -d "$BUILDDIR/$ARCH" ]; then

    cd "$BUILDDIR/$ARCH"

    set -x

    make distclean

    set +x

  fi

  if [ -d "$INSTALLDIR/$ARCH" ]; then

    rm -rf "$INSTALLDIR/$ARCH"

  fi
}

function autoreconfigure()
{

  echo "AutoReconfiguring..."

  set -x

  autoreconf -fiv configure.ac 2> /dev/null

  set +x

  if [[ $? -ne 0 ]] ; then

    echo "Errors while running autoreconf. Exiting.."

    exit 1

  fi
}

function configure()
{
  echo "Configuring..."
   # We have to temporarily unset SDKROOT for configuration to go through
  PREVIOUS_SDKROOT="$SDKROOT"
  SDKROOT=""
  echo "Temporaily unsetting SDKROOT"

  set -x

  (cd "$BUILDDIR/$ARCH" ; "$SRCDIR/configure" \
    --prefix="$BUILDDIR/$ARCH" \
    --host "$HOST" \
    CFLAGS="$CFLAGS" \
    LDFLAGS="$LDFLAGS" \
    CCASFLAGS="$CCASFLAGS" \
    NASM="$NASMFLAGS")

  set +x

  if [[ $? -ne 0 ]] ; then

    echo "Errors while running configure. Exiting.."

    echo "$PREFIX/config.log"

    exit 1
  fi

  echo "Setting SDKROOT Back to $PREVIOUS_SDKROOT"
  SDKROOT="$PREVIOUS_SDKROOT"
}

function build()
{
  echo "Building.."

  set -x

  make -j$CPUS

  make install

  set +x

  if [[ $? -ne 0 ]] ; then

      echo "Errors while running make. Exiting.."

      exit 1
  fi
}

function build_for_arch()
{
    ARCH=$1

    HOST=$2

    EXTRA_CFLAGS_AND_LDFLAGS=$3

    EXTRA_CCASFLAGS=$4

    NASMFLAGS=$5

    BUILDDIRECTORY="$BUILDDIR/$ARCH"

    PREFIX="$BUILDDIRECTORY"

    export CFLAGS="-arch ${ARCH} -pipe $OPTIMIZATION_LEVEL -isysroot ${IOS_SYSROOT} -miphoneos-version-min=${IPHONEOS_DEPLOYMENT_TARGET} -fembed-bitcode $EXTRA_CFLAGS_AND_LDFLAGS"

    export HOST="$HOST"

    export LDFLAGS="-arch ${ARCH} -isysroot ${IOS_SYSROOT} $EXTRA_CFLAGS_AND_LDFLAGS"

    export CCASFLAGS="$EXTRA_CCASFLAGS"

    mkdir -p "$BUILDDIRECTORY" && cd "$BUILDDIRECTORY"

    configure $ARCH

    build

    HEADER_COPY_DIR="${HEADER_DIR}/$ARCH"
    INCLUDE_COPY_DIR="${BUILDDIR}/$ARCH/include"

    echo "Copying headers from ${INCLUDE_COPY_DIR} to ${HEADER_COPY_DIR}"

    mkdir -p "${HEADER_COPY_DIR}"

    cp "${INCLUDE_COPY_DIR}/"*.h "${HEADER_COPY_DIR}/"
}

# add gas-preprocessor to PATH

PATH="$EXTSRCDIR/gas-preprocessor":$PATH

echo "OPTIMIZATION_LEVEL=$OPTIMIZATION_LEVEL"

# Build + combine the binaries

if [ "$ACTION" == "clean" ]
then

    if [ "$PLATFORM" == "iPhoneSimulator" ]
    then
        clean "i386"

        clean "x86_64"
    else
        clean "armv7"

        #clean ${BUILDDIR}/armv7s ${INSTALLDIR}/armv7s

        clean "arm64"
    fi

    if [ -d "$HEADER_DIR" ]; then

        rm -rf "$HEADER_DIR"
    fi

    rm -f "$INSTALLDIR/*.a"

elif [ "$ACTION" == "build" ] || [ "$ACTION" == "install" ]
then
    # call autoreconf in source dir
    cd "$SRCDIR"
    autoreconfigure

    if [ "$PLATFORM" == "iPhoneSimulator" ]
    then
        #nasm -hf >/dev/null 2>&1 || { echo "error: autoconf is required but it's not installed.  Aborting." >&2; exit 1; }

        # build for i686
        build_for_arch i386 i386-apple-darwin "-m32" "" ""

        # build for x86_64
        build_for_arch x86_64 x86_64-apple-darwin "" "" "/usr/local/bin/nasm"

        echo "Creating Universal Binary for $PLATFORM"

        set -x

        (cd "$INSTALLDIR" && lipo -create "${BUILDDIR}/i386/lib/libturbojpeg.a" "${BUILDDIR}/x86_64/lib/libturbojpeg.a" -o "$PRODUCT_NAME".a)

        set +x

        echo "BUILT PRODUCT: $INSTALLDIR/$PRODUCT_NAME.a"
    else
        # build for ARMv7
        build_for_arch armv7 arm-apple-darwin10 "-mfloat-abi=softfp" "-no-integrated-as -arch armv7 $IPHONEOSVERSION" ""

        # build for ARMv8
        build_for_arch arm64 aarch64-apple-darwin "" "" ""

        echo "Creating Universal Binary for $PLATFORM"

        set -x

        (cd "$INSTALLDIR" && lipo -create "${BUILDDIR}/arm64/lib/libturbojpeg.a" "${BUILDDIR}/armv7/lib/libturbojpeg.a" -o "$PRODUCT_NAME".a)

        set +x

        echo "BUILT PRODUCT: $INSTALLDIR/$PRODUCT_NAME.a"
    fi

else
  echo "Unrecognized Action: $ACTION"
fi
