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
SRCDIR="$EXTSRCDIR/libcurl"
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

if [ "$ACTION" == "build" ];
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

####### Custom Configuration

if [ "$CONFIGURATION" == "Debug" ];
then
OPTIMIZATION_LEVEL="-O1"
else
OPTIMIZATION_LEVEL="-Os"
fi

echo "OPTIMIZATION_LEVEL=$OPTIMIZATION_LEVEL"

SSL_FLAG=--with-darwinssl

echo "SSL_FLAG=$SSL_FLAG"

function clean()
{
    BUILDDIRECTORY=$1

    INSTALLDIRECTORY=$2

    echo "Cleaning $BUILDDIRECTORY"

    if [ -d "$BUILDDIRECTORY" ]; then

        cd "$BUILDDIRECTORY"

        set -x

        make distclean

        set +x
    fi

    echo "Cleaning $INSTALLDIRECTORY"

    if [ -d "$INSTALLDIRECTORY" ]; then

        rm -rf "$INSTALLDIRECTORY"

    fi
}

function run_autoconf_to_create_configure_script()
{
    if [ ! -x "$SRCDIR/configure" ]; then

        echo "Curl needs external tools to be compiled"

        echo "Make sure you have autoconf, automake and libtool installed"

        set -x

        (cd $SRCDIR && ./buildconf 2>/dev/null)

        set +x

        EXITCODE=$?

        if [ $EXITCODE -ne 0 ]; then

            echo "Error running the buildconf program"

            cd "$PWD"

            exit $EXITCODE
        fi
    fi
}

function configure_for_arch()
{
    ARCH=$1

    HOST=$2

    SYSROOT=$3

    PREFIX="$4"

    set -x

    export PATH="${DEVROOT}/usr/bin/:${PATH}"

    export CFLAGS="-arch ${ARCH} -pipe $OPTIMIZATION_LEVEL -isysroot ${IOS_SYSROOT} -miphoneos-version-min=${IPHONEOS_DEPLOYMENT_TARGET} -fembed-bitcode"

    export LDFLAGS="-arch ${ARCH} -isysroot ${IOS_SYSROOT}"

    PREVIOUS_SDKROOT="$SDKROOT"

    SDKROOT=""

    echo "Temporaily unsetting SDKROOT"

    (cd "$PREFIX" ; "$SRCDIR/configure" --disable-shared --enable-static --enable-threaded-resolver ${SSL_FLAG} --host="${HOST}" --prefix="${PREFIX}")

    if [[ $? -ne 0 ]] ; then

        echo "Errors while running configure. Exiting.."

        echo "$PREFIX/config.log"

        exit 1
    fi

    set +x

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
    configure_for_arch "$1" "$2" "$3" "$4" && (cd "$4" ; build)
}

####### Build

if [ "$ACTION" == "clean" ]
then

    if [ "$PLATFORM" == "iPhoneSimulator" ]
    then
        clean "${BUILDDIR}/i386" "${INSTALLDIR}/i386"

        clean "${BUILDDIR}/x86_64" "${INSTALLDIR}/x86_64"
    else
        clean "${BUILDDIR}/armv7" "${INSTALLDIR}/armv7"

        #clean ${BUILDDIR}/armv7s ${INSTALLDIR}/armv7s

        clean "${BUILDDIR}/arm64" "${INSTALLDIR}/arm64"
    fi

    if [ -d "$HEADER_DIR" ]; then

        rm -rf "$HEADER_DIR"
    fi

    rm -f "$INSTALLDIR/*.a"

elif [ "$ACTION" == "build" ] || [ "$ACTION" == "install" ]
then
    run_autoconf_to_create_configure_script

    if [ "$PLATFORM" == "iPhoneSimulator" ]
    then

        mkdir -p "${BUILDDIR}/i386" && cd "${BUILDDIR}/i386"

        build_for_arch i386 i386-apple-darwin "$IOS_SYSROOT" "${BUILDDIR}/i386"

        mkdir -p "${BUILDDIR}/x86_64" && cd "${BUILDDIR}/x86_64"

        build_for_arch x86_64 x86_64-apple-darwin "$IOS_SYSROOT" "${BUILDDIR}/x86_64"

        HEADER_COPY_DIR="${HEADER_DIR}/i386"

        echo "Copying headers to ${HEADER_COPY_DIR}"

        mkdir -p "${HEADER_COPY_DIR}"

        cp -R "${BUILDDIR}/i386/include/curl" "${HEADER_COPY_DIR}/"

        HEADER_COPY_DIR="${HEADER_DIR}/x86_64"

        echo "Copying headers to ${HEADER_COPY_DIR}"

        mkdir -p "${HEADER_COPY_DIR}"

        cp -R "${BUILDDIR}/x86_64/include/curl" "${HEADER_COPY_DIR}/"

        echo "Creating Universal Binary for $PLATFORM"

        (cd "$INSTALLDIR" && lipo -create "${BUILDDIR}/x86_64/lib/libcurl.a" "${BUILDDIR}/i386/lib/libcurl.a" -o "$PRODUCT_NAME".a)

        echo "BUILT PRODUCT: $INSTALLDIR/$PRODUCT_NAME.a"

        lipo -info "$INSTALLDIR/$PRODUCT_NAME.a"

    else

        mkdir -p "${BUILDDIR}/armv7" && cd "${BUILDDIR}/armv7"

        build_for_arch armv7 armv7-apple-darwin "$IOS_SYSROOT" "${BUILDDIR}/armv7"

        #mkdir -p "${BUILDDIR}/armv7s" && cd "${BUILDDIR}/armv7s"

        #build_for_arch armv7s armv7-apple-darwin "$IOS_SYSROOT" "${BUILDDIR}/armv7s"

        mkdir -p "${BUILDDIR}/arm64" && cd "${BUILDDIR}/arm64"

        build_for_arch arm64 arm-apple-darwin "$IOS_SYSROOT" "${BUILDDIR}/arm64"

        HEADER_COPY_DIR="${HEADER_DIR}/armv7"

        echo "Copying headers to ${HEADER_COPY_DIR}"

        mkdir -p "${HEADER_COPY_DIR}"

        cp -R "${BUILDDIR}/armv7/include/curl" "${HEADER_COPY_DIR}/"

        HEADER_COPY_DIR="${HEADER_DIR}/arm64"

        echo "Copying headers to ${HEADER_COPY_DIR}"

        mkdir -p "${HEADER_COPY_DIR}"

        cp -R "${BUILDDIR}/arm64/include/curl" "${HEADER_COPY_DIR}/"

        echo "Creating Universal Binary for $PLATFORM"

        (cd "$INSTALLDIR" && lipo -create "${BUILDDIR}/arm64/lib/libcurl.a" "${BUILDDIR}/armv7/lib/libcurl.a" -o "$PRODUCT_NAME.a")

        echo "BUILT PRODUCT: $INSTALLDIR/$PRODUCT_NAME.a"

        lipo -info "$INSTALLDIR/$PRODUCT_NAME.a"

    fi

else
    echo "Unrecognized Action: $ACTION"
fi

