#!/bin/bash

cd /root/src/
git clone https://repo.or.cz/nasm.git
cd nasm

VER=`git tag --list "nasm-*" | grep -v rc | tail -n1`
git checkout tags/${VER}

./autogen.sh
PATH="/root/bin:$PATH" ./configure --prefix="/root/ffmpeg_build" --bindir="/root/bin"
make
make install

/root/bin/nasm -v
