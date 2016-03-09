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
EXTSRCDIR=$DIR/../../src
SRCDIR=$EXTSRCDIR/libjpeg-turbo
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

if [ "$ACTION" == "build" ];
then
	if [ -f $INSTALLDIR/$PRODUCT_NAME.a ];
	then
	echo "Not building since file already exists at $INSTALLDIR/$PRODUCT_NAME.a. Please clean to rebuild"
	lipo -info $INSTALLDIR/$PRODUCT_NAME.a
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
  echo "Cleaning.."
  if [ -d "$BUILDDIRECTORY" ]; then
    cd $BUILDDIRECTORY

    set -x

    make distclean

    set +x
  fi
  if [ -d "$INSTALLDIRECTORY" ]; then
    rm -rf "$INSTALLDIRECTORY"
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
  PREVIOUS_SDKROOT=$SDKROOT
  SDKROOT=""
  echo "Temporaily unsetting SDKROOT"

  set -x

  (cd $BUILDDIRECTORY ;$SRCDIR/configure \
    --prefix=$BUILDDIRECTORY \
    --host "$HOST" \
    CC="$IOS_GCC" \
    LD="$IOS_GCC" \
    CFLAGS="$CFLAGS" \
    LDFLAGS="$LDFLAGS" \
    CCASFLAGS="$CCASFLAGS" )

  set +x

  if [[ $? -ne 0 ]] ; then
    echo "Errors while running configure. Exiting.."
    exit 1
  fi

  echo "Setting SDKROOT Back to $PREVIOUS_SDKROOT"
  SDKROOT=$PREVIOUS_SDKROOT
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

# add gas-preprocessor to PATH
PATH=$EXTSRCDIR/gas-preprocessor:$PATH

echo "OPTIMIZATION_LEVEL=$OPTIMIZATION_LEVEL"

if [ "$ACTION" == "build" ];
then
  # call autoreconf in source dir
  cd $SRCDIR
  autoreconfigure
fi

# build for ARMv7

arch="armv7"
BUILDDIRECTORY=$BUILDDIR/$arch
INSTALLDIRECTORY=$INSTALLDIR/$arch
IOS_CFLAGS="-arch $arch $IPHONEOSVERSION"
HOST="arm-apple-darwin10"
CFLAGS="-mfloat-abi=softfp -isysroot $IOS_SYSROOT $OPTIMIZATION_LEVEL $IOS_CFLAGS"
LDFLAGS="-mfloat-abi=softfp -isysroot $IOS_SYSROOT $IOS_CFLAGS"
CCASFLAGS="-no-integrated-as $IOS_CFLAGS"

if [ "$ACTION" == "clean" ]
then
  clean
elif [ "$ACTION" == "build" ]
then
  mkdir -p $BUILDDIRECTORY && cd $BUILDDIRECTORY 
  configure
  build

  HEADER_COPY_DIR=${HEADER_DIR}/armv7
  echo "Copying headers to ${HEADER_COPY_DIR}"
  mkdir -p ${HEADER_COPY_DIR}
  cp ${BUILDDIR}/armv7/include/*.h ${HEADER_COPY_DIR}/

else
  echo "Unrecognized Action: $ACTION"
fi

# build for ARMv7s

arch="armv7s"
BUILDDIRECTORY=$BUILDDIR/$arch
INSTALLDIRECTORY=$INSTALLDIR/$arch
IOS_CFLAGS="-arch $arch $IPHONEOSVERSION"
HOST="arm-apple-darwin10"
CFLAGS="-mfloat-abi=softfp -isysroot $IOS_SYSROOT $OPTIMIZATION_LEVEL $IOS_CFLAGS"
LDFLAGS="-mfloat-abi=softfp -isysroot $IOS_SYSROOT $IOS_CFLAGS"
CCASFLAGS="-no-integrated-as $IOS_CFLAGS"

if [ "$ACTION" == "clean" ]
then
  clean
elif [ "$ACTION" == "build" ]
then
  mkdir -p $BUILDDIRECTORY && cd $BUILDDIRECTORY
  configure
  build

  HEADER_COPY_DIR=${HEADER_DIR}/armv7s
  echo "Copying headers to ${HEADER_COPY_DIR}"
  mkdir -p ${HEADER_COPY_DIR}
  cp ${BUILDDIR}/armv7s/include/*.h ${HEADER_COPY_DIR}/

else
  echo "Unrecognized Action: $ACTION"
fi

# build for ARMv8

arch="arm64"
BUILDDIRECTORY=$BUILDDIR/$arch
INSTALLDIRECTORY=$INSTALLDIR/$arch
IOS_CFLAGS="-arch $arch $IPHONEOSVERSION"
HOST="aarch64-apple-darwin"
CFLAGS="-isysroot $IOS_SYSROOT $OPTIMIZATION_LEVEL $IOS_CFLAGS" 
LDFLAGS="-isysroot $IOS_SYSROOT $IOS_CFLAGS"
CCASFLAGS=""

if [ "$ACTION" == "clean" ]
then
  clean
elif [ "$ACTION" == "build" ]
then
  mkdir -p $BUILDDIRECTORY && cd $BUILDDIRECTORY
  configure
  build

  HEADER_COPY_DIR=${HEADER_DIR}/arm64
  echo "Copying headers to ${HEADER_COPY_DIR}"
  mkdir -p ${HEADER_COPY_DIR}
  cp ${BUILDDIR}/arm64/include/*.h ${HEADER_COPY_DIR}/

else
  echo "Unrecognized Action: $ACTION"
fi

# Combine the binaries

if [ "$ACTION" == "clean" ]
then

  echo "Removing Headers $HEADER_DIR"

  if [ -d "$HEADER_DIR" ]; then
    rm -rf "$HEADER_DIR"
  fi

  echo "Removing Universal Binaries"
  rm -f $INSTALLDIR/*.a

elif [ "$ACTION" == "build" ]
then

  echo "Creating Universal Binary"
  set -x
  (cd $INSTALLDIR && lipo -create ${BUILDDIR}/arm64/lib/libturbojpeg.a ${BUILDDIR}/armv7/lib/libturbojpeg.a ${BUILDDIR}/armv7s/lib/libturbojpeg.a -o "$PRODUCT_NAME".a)
  set +x
  echo "BUILT PRODUCT: $INSTALLDIR/$PRODUCT_NAME.a"
else
  echo "Unrecognized Action: $ACTION"
fi
