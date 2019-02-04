FROM linuxserver/sabnzbd:latest
LABEL maintainer "T Koopman"

RUN \
  apt-get update && \
  apt-get install -y \
          libxcb-shm0 \
          libxcb-shape0 \
          libxcb-xfixes0 \
          libasound2 \
          libsdl2-2.0-0 \
          libdrm-nouveau2 \
          libxv1 \
          libva1 \
          libass5 \
          libvpx3 \
          libfdk-aac0 \
          libmp3lame0 \
          libopus0 \
          libx264-148 \
          libx265-79 \
          libva-drm1 \
          libva-x11-1 \
          libvdpau1 && \
  apt-get install -y \
          autoconf \
          automake \
          build-essential \
          cmake \
          git-core \
          libx264-dev \
          libx265-dev \
          libass-dev \
          libfdk-aac-dev \
          libfreetype6-dev \
          libnuma-dev \
          libmp3lame-dev \
          libopus-dev \
          libsdl2-dev \
          libtool \
          libva-dev \
          libvdpau-dev \
          libvorbis-dev \
          libvpx-dev \
          libxcb1-dev \
          libxcb-shm0-dev \
          libxcb-xfixes0-dev \
          pkg-config \
          texinfo \
          wget \
          yasm \
          zlib1g-dev && \
  mkdir -p /root/src /root/bin && \
  cd /root/src && \
  wget https://www.nasm.us/pub/nasm/releasebuilds/2.13.03/nasm-2.13.03.tar.bz2 && \
  tar xjvf nasm-2.13.03.tar.bz2 && \
  cd nasm-2.13.03 && \
  ./autogen.sh && \
  PATH="/root/bin:$PATH" ./configure --prefix="/root/ffmpeg_build" --bindir="/root/bin" && \
  make && \
  make install && \
  cd /root/src && \
  git -C aom pull 2> /dev/null || git clone --depth 1 https://aomedia.googlesource.com/aom && \
  mkdir -p aom_build && \
  cd aom_build && \
  PATH="/root/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="/root/ffmpeg_build" -DENABLE_SHARED=off -DENABLE_NASM=on ../aom && \
  PATH="/root/bin:$PATH" make && \
  make install && \
  cd /root/src && \
  wget https://ffmpeg.org/releases/ffmpeg-4.1.tar.bz2 && \
  tar xjvf ffmpeg-4.1.tar.bz2 && \
  cd ffmpeg-4.1 && \
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
    --enable-nonfree && \
  PATH="/root/bin:$PATH" make && \
  make install && \
  hash -r && \
  apt-get purge -y \
          autoconf \
          automake \
          build-essential \
          cmake \
          git-core \
          libx264-dev \
          libx265-dev \
          libass-dev \
          libfdk-aac-dev \
          libfreetype6-dev \
          libnuma-dev \
          libmp3lame-dev \
          libopus-dev \
          libsdl2-dev \
          libtool \
          libva-dev \
          libvdpau-dev \
          libvorbis-dev \
          libvpx-dev \
          libxcb1-dev \
          libxcb-shm0-dev \
          libxcb-xfixes0-dev \
          pkg-config \
          texinfo \
          wget \
          yasm \
          zlib1g-dev && \
  apt autoremove -y && \
  apt-get clean && \
  cp -v /root/bin/* /usr/bin/ && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/ffmpeg_build /root/src /root/bin

COPY ffmpegvalidator /scripts/ffmpegvalidator
RUN chmod +x /scripts/ffmpegvalidator
