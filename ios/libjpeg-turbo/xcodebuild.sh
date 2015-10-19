#!/bin/bash

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

ACTION=$1

[ -z "$PROJECT_DIR" ] && PROJECT_DIR=$SCRIPT_DIR
[ -z "$CONFIGURATION_TEMP_DIR" ] && CONFIGURATION_TEMP_DIR=$SCRIPT_DIR/build
[ -z "$CONFIGURATION_BUILD_DIR" ] && CONFIGURATION_BUILD_DIR=$SCRIPT_DIR/install
[ -z "$ACTION" ] && ACTION="build"
[ -z "$PRODUCT_NAME" ] && PRODUCT_NAME="libturbojpeg"
[ -z "$CONFIGURATION" ] && CONFIGURATION="Release"

"$PROJECT_DIR"/build.sh "$CONFIGURATION_TEMP_DIR" "$CONFIGURATION_BUILD_DIR" "$ACTION" "$PRODUCT_NAME" "$CONFIGURATION"

if [[ "$CONFIGURATION_BUILD_DIR" == "$PROJECT_DIR"* ]]
then
  # If the build is inside the source directory then create symbolic link in root external repository to make linking work

  EXTERNAL_PROJECT_DIR="$PROJECT_DIR/../.."
  EXTERNAL_PROJECT_BUILD_DIR="$EXTERNAL_PROJECT_DIR/build/$CONFIGURATION-iphoneos"
    
  if [ -h "$EXTERNAL_PROJECT_BUILD_DIR/$PRODUCT_NAME".a ] ; then
    echo "Removing existing symbolic link at $EXTERNAL_PROJECT_BUILD_DIR/$PRODUCT_NAME.a"
    rm "$EXTERNAL_PROJECT_BUILD_DIR/$PRODUCT_NAME".a
  fi

  set -x
  echo "Creating symbolic link at $EXTERNAL_PROJECT_BUILD_DIR/$PRODUCT_NAME".a
  ln -s "$CONFIGURATION_BUILD_DIR/$PRODUCT_NAME".a "$EXTERNAL_PROJECT_BUILD_DIR/$PRODUCT_NAME".a
  set +x
fi

