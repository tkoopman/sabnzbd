#!/bin/bash -e
apt-get update

PKGS=""
# Packages required to build and run ffmpeg
PKGS+=`apt-cache --names-only search '^libxcb-shm[0-9]+$' | awk '{print " "$1;}'`
PKGS+=`apt-cache --names-only search '^libxcb-shape[0-9]+$' | awk '{print " "$1;}'`
PKGS+=`apt-cache --names-only search '^libxcb-xfixes[0-9]+$' | awk '{print " "$1;}'`
PKGS+=`apt-cache --names-only search '^libasound[0-9]+$' | awk '{print " "$1; exit}'`
PKGS+=`apt-cache --names-only search '^libxv[0-9]+$' | awk '{print " "$1;}'`
PKGS+=`apt-cache --names-only search '^libva[0-9]+$' | awk '{print " "$1;}'`
PKGS+=`apt-cache --names-only search '^libass[0-9]+$' | awk '{print " "$1;}'`
PKGS+=`apt-cache --names-only search '^libvpx[0-9]+$' | awk '{print " "$1;}'`
PKGS+=`apt-cache --names-only search '^libfdk-aac[0-9]+$' | awk '{print " "$1;}'`
PKGS+=`apt-cache --names-only search '^libmp3lame[0-9]+$' | awk '{print " "$1;}'`
PKGS+=`apt-cache --names-only search '^libopus[0-9]+$' | awk '{print " "$1;}'`
PKGS+=`apt-cache --names-only search '^libx264-[0-9]+$' | awk '{print " "$1;}'`
PKGS+=`apt-cache --names-only search '^libx265-[0-9]+$' | awk '{print " "$1;}'`
PKGS+=`apt-cache --names-only search '^libva-drm[0-9]+$' | awk '{print " "$1;}'`
PKGS+=`apt-cache --names-only search '^libva-x11-[0-9]+$' | awk '{print " "$1;}'`
PKGS+=`apt-cache --names-only search '^libvdpau[0-9]+$' | awk '{print " "$1;}'`
PKGS+=`apt-cache --names-only search '^libsdl2-2\.0-[0-9]+$' | awk '{print " "$1;}'`

echo $PKGS > /root/packages

# Packages only required for build
PKGS+=" autoconf automake build-essential cmake \
git-core libx264-dev libx265-dev libass-dev \
libfdk-aac-dev libfreetype6-dev libnuma-dev \
libmp3lame-dev libopus-dev libsdl2-dev \
libtool libva-dev libvdpau-dev libvorbis-dev \
libvpx-dev libxcb1-dev pkg-config texinfo \
wget yasm zlib1g-dev"
PKGS+=`apt-cache --names-only search '^libxcb-shm[0-9]+-dev$' | awk '{print " "$1;}'`
PKGS+=`apt-cache --names-only search '^libxcb-xfixes[0-9]+-dev$' | awk '{print " "$1;}'`
PKGS+=`apt-cache --names-only search '^libdrm-nouveau[0-9]+$' | awk '{print " "$1;}'`

apt-get install -y $PKGS
