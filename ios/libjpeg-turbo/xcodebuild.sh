#!/bin/bash

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

ACTION=$1

[ -z "$PROJECT_DIR" ] && PROJECT_DIR=$SCRIPT_DIR
[ -z "$OBJROOT" ] && OBJROOT=$SCRIPT_DIR/build
[ -z "$SYMROOT" ] && SYMROOT=$SCRIPT_DIR/install
[ -z "$ACTION" ] && ACTION="build"

echo "Running build script with $OBJROOT as OBJROOT and $SYMROOT as SYMROOT and $ACTION as ACTION"

"$PROJECT_DIR"/build.sh "$OBJROOT" "$SYMROOT" "$ACTION"


