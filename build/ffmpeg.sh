#!/bin/bash

cd /root/src/
git clone https://git.ffmpeg.org/ffmpeg.git
cd ffmpeg

VER=`git tag | grep -E '^n[0-9]+.[0-9]+.[0-9]+$' | tail -n1`
git checkout tags/${VER}

PATH="/root/bin:$PATH" PKG_CONFIG_PATH="/root/ffmpeg_build/lib/pkgconfig" ./configure \
    --prefix="/root/ffmpeg_build" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I/root/ffmpeg_build/include" \
    --extra-ldflags="-L/root/ffmpeg_build/lib" \
    --extra-libs="-lpthread -lm" \
    --bindir="/root/bin" \
    --enable-gpl \
    --enable-libaom \
    --enable-libass \
    --enable-libfdk-aac \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libopus \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libx264 \
    --enable-libx265 \
    --enable-nonfree
PATH="/root/bin:$PATH" make
make install

/root/bin/ffmpeg -version
