#!/bin/bash

DEFAULT_PRODUCT_NAME="libjpeg-turbo"

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

ACTION=$1

[ -z "$PROJECT_DIR" ] && PROJECT_DIR=$SCRIPT_DIR
[ -z "$CONFIGURATION_TEMP_DIR" ] && CONFIGURATION_TEMP_DIR=$SCRIPT_DIR/build
[ -z "$CONFIGURATION_BUILD_DIR" ] && CONFIGURATION_BUILD_DIR=$SCRIPT_DIR/install
[ -z "$ACTION" ] && ACTION="build"
[ -z "$PRODUCT_NAME" ] && PRODUCT_NAME=$DEFAULT_PRODUCT_NAME
[ -z "$CONFIGURATION" ] && CONFIGURATION="Release"
[ -z "$IPHONEOS_DEPLOYMENT_TARGET" ] && IPHONEOS_DEPLOYMENT_TARGET = 6.0
[ -z "$ARCHS" ] && PLATFORM=iPhoneSimulator

HEADER_DIR=$CONFIGURATION_BUILD_DIR/include/$PRODUCT_NAME

if [[ "$ARCHS" == *"armv7"* ]] || [[ "$ARCHS" == *"arm64"* ]] ; then
    PLATFORM=iPhoneOS
else
    PLATFORM=iPhoneSimulator
fi

"$PROJECT_DIR"/build.sh "$CONFIGURATION_TEMP_DIR" "$CONFIGURATION_BUILD_DIR" "$ACTION" "$PRODUCT_NAME" "$CONFIGURATION" "$IPHONEOS_DEPLOYMENT_TARGET" "$PLATFORM" "$HEADER_DIR"

if [[ "$CONFIGURATION_BUILD_DIR" == "$PROJECT_DIR"* ]]
then
    # If the build is inside the source directory then create symbolic link in root external repository to make linking work

    EXTERNAL_PROJECT_DIR="$PROJECT_DIR/../.."
    EXTERNAL_PROJECT_BUILD_DIR="$EXTERNAL_PROJECT_DIR/build/$CONFIGURATION-iphoneos"
    EXTERNAL_PROJECT_INCLUDE_DIR="$EXTERNAL_PROJECT_BUILD_DIR/include"

    #Create EXTERNAL_PROJECT_INCLUDE_DIR directory if not exists
    [ -d "$EXTERNAL_PROJECT_INCLUDE_DIR" ] || mkdir -p "$EXTERNAL_PROJECT_INCLUDE_DIR"

    #Copy Headers
    echo "Copying Headers to $EXTERNAL_PROJECT_INCLUDE_DIR"
    cp -R "$HEADER_DIR" "$EXTERNAL_PROJECT_INCLUDE_DIR/"

    if [ -h "$EXTERNAL_PROJECT_BUILD_DIR/$PRODUCT_NAME".a ] ;
    then
    echo "Removing existing symbolic link at $EXTERNAL_PROJECT_BUILD_DIR/$PRODUCT_NAME.a"
    rm "$EXTERNAL_PROJECT_BUILD_DIR/$PRODUCT_NAME".a
    fi

    set -x
    echo "Creating symbolic link at $EXTERNAL_PROJECT_BUILD_DIR/$PRODUCT_NAME".a
    ln -s "$CONFIGURATION_BUILD_DIR/$PRODUCT_NAME".a "$EXTERNAL_PROJECT_BUILD_DIR/$PRODUCT_NAME".a
    set +x
fi
