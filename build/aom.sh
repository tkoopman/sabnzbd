#!/bin/bash

cd /root/src/
git clone --depth 1 https://aomedia.googlesource.com/aom

mkdir -p /root/src/aom_build
cd /root/src/aom_build
PATH="/root/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="/root/ffmpeg_build" -DENABLE_SHARED=off -DENABLE_NASM=on ../aom
PATH="/root/bin:$PATH" make
make install

exit 0
