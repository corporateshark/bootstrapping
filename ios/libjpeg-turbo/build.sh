if ! [ $# -eq 5 ]
  then
    echo "Usage: build.sh <build_directory> <install_directory> <action> <product_name> <debug/release>"
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


function clean(){
  echo "Cleaning.."
  if [ -d "$BUILDDIRECTORY" ]; then
    cd $BUILDDIRECTORY
    make distclean
  fi
  if [ -d "$INSTALLDIRECTORY" ]; then
    rm -rf "$INSTALLDIRECTORY"
  fi
}

function autoreconfigure(){
  echo "AutoReconfiguring..."
  autoreconf -fiv configure.ac 2> /dev/null
  if [[ $? -ne 0 ]] ; then
    echo "Errors while running autoreconf. Exiting.."
    exit 1
  fi
}

function configure(){
  echo "Configuring..."
   # We have to temporarily unset SDKROOT for configuration to go through
  PREVIOUS_SDKROOT=$SDKROOT
  SDKROOT=""
  echo "Temporaily unsetting SDKROOT"

  $SRCDIR/configure \
    --prefix=$INSTALLDIRECTORY \
    --host "$HOST" \
    CC="$IOS_GCC" \
    LD="$IOS_GCC" \
    CFLAGS="$CFLAGS" \
    LDFLAGS="$LDFLAGS" \
    CCASFLAGS="$CCASFLAGS"
  if [[ $? -ne 0 ]] ; then
    echo "Errors while running configure. Exiting.."
    exit 1
  fi

  echo "Setting SDKROOT Back to $PREVIOUS_SDKROOT"
  SDKROOT=$PREVIOUS_SDKROOT
}

function build(){
  echo "Building.."
  make -j$CPUS
  make install
  if [[ $? -ne 0 ]] ; then
      echo "Errors while running make. Exiting.."
      exit 1
  fi
}


# get some absolute paths
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILDDIR="$( cd "$1" && pwd )"
INSTALLDIR="$( cd "$2" && pwd )"
EXTSRCDIR=$DIR/../../src
SRCDIR=$EXTSRCDIR/libjpeg-turbo
ACTION="$3"
PRODUCT_NAME="$4"
CONFIGURATION="$5"

echo "BUILDDIR=$BUILDDIR"
echo "INSTALLDIR=$INSTALLDIR"
echo "SRCDIR=$SRCDIR"
echo "ACTION=$ACTION"
echo "PRODUCT_NAME=$PRODUCT_NAME"
echo "CONFIGURATION=$CONFIGURATION"


if [ "$ACTION" == "build" ];
then
  if [ -f $INSTALLDIR/$PRODUCT_NAME.a ];
  then
    echo "Not building since file already exists at $INSTALLDIR/$PRODUCT_NAME.a. Please clean to rebuild"
    exit 0
  fi
fi

# add gas-preprocessor to PATH
PATH=$EXTSRCDIR/gas-preprocessor:$PATH

# some useful variables
IOS_PLATFORMDIR=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform
IOS_SYSROOT=$IOS_PLATFORMDIR/Developer/SDKs/iPhoneOS.sdk
IOS_GCC=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang
IPHONEOSVERSION="-miphoneos-version-min=5.1"
CPUS=$(sysctl -n hw.logicalcpu_max)

if [ "$CONFIGURATION" == "Debug" ];
then
    OPTIMIZATION_LEVEL="-O1"
else
    OPTIMIZATION_LEVEL="-O3"
fi

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
else
  echo "Unrecognized Action: $ACTION"
fi

# Combine the binaries

if [ "$ACTION" == "clean" ]
then
  echo "Removing Universal Binaries"
  rm -f $INSTALLDIR/*.a
elif [ "$ACTION" == "build" ]
then
  echo "Creating Universal Binary"
  (cd $INSTALLDIR && lipo -create arm64/lib/libturbojpeg.a armv7/lib/libturbojpeg.a armv7s/lib/libturbojpeg.a -o "$PRODUCT_NAME".a)
  echo "BUILT PRODUCT: $INSTALLDIR/$PRODUCT_NAME.a"
else
  echo "Unrecognized Action: $ACTION"
fi
