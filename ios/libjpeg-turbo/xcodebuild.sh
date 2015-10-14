#!/bin/bash

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

[ -z "$PROJECT_DIR" ] && PROJECT_DIR=$SCRIPT_DIR
[ -z "$OBJROOT" ] && OBJROOT=$SCRIPT_DIR

echo "Running build script with $OBJROOT as OBJROOT"

"$PROJECT_DIR"/build.sh "$OBJROOT"


