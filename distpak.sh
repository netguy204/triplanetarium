#!/usr/bin/env bash

DIST=$1

if [ -d $DIST ]; then
    rm -rf $DIST
fi

mkdir -p $DIST
mkdir $DIST/giggle

cp equals1-linux $DIST
chmod +x $DIST/equals1-linux

cp equals1.exe $DIST

cp giggle/engine/sdlmain_nt.bin $DIST/giggle/runtime-mac
cp run_on_mac.command $DIST/
chmod +x $DIST/giggle/runtime-mac

cp -r resources $DIST/
cp -r giggle/engine_resources $DIST/giggle/
