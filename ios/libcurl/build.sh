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

set -x

make distclean

set +x
fi
if [ -d "$INSTALLDIRECTORY" ]; then
rm -rf "$INSTALLDIRECTORY"
fi
}

function build(){
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
