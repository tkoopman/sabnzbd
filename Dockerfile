FROM linuxserver/sabnzbd:latest
LABEL maintainer "T Koopman"

RUN \
  apt-get update && \
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
    autoconf automake autotools-dev binutils build-essential bzip2 cmake \
    cmake-data cpp cpp-5 dpkg-dev fakeroot fontconfig-config fonts-dejavu-core \
    g++ g++-5 gcc gcc-5 git git-core git-man i965-va-driver ifupdown iproute2 \
    isc-dhcp-client isc-dhcp-common less libalgorithm-diff-perl \
    libalgorithm-diff-xs-perl libalgorithm-merge-perl libarchive13 libasan2 \
    libasound2 libasound2-data libasound2-dev libass-dev libass5 libasyncns0 \
    libatm1 libatomic1 libauthen-sasl-perl libboost-filesystem1.58.0 \
    libboost-system1.58.0 libbsd0 libc-dev-bin libc6-dev libcapnp-0.5.3 libcc1-0 \
    libcilkrts5 libcurl3 libdbus-1-dev libdns-export162 libdpkg-perl \
    libdrm-amdgpu1 libdrm-common libdrm-dev libdrm-intel1 libdrm-nouveau2 \
    libdrm-radeon1 libdrm2 libedit2 libegl1-mesa libegl1-mesa-dev libelf1 \
    libencode-locale-perl liberror-perl libexpat1-dev libfakeroot libfdk-aac-dev \
    libfdk-aac0 libfile-fcntllock-perl libfile-listing-perl libflac8 \
    libfont-afm-perl libfontconfig1 libfontconfig1-dev libfreetype6 \
    libfreetype6-dev libfribidi-dev libfribidi0 libgbm1 libgcc-5-dev libgdbm3 \
    libgl1-mesa-dev libgl1-mesa-dri libgl1-mesa-glx libglapi-mesa libgles2-mesa \
    libgles2-mesa-dev libglib2.0-bin libglib2.0-dev libglu1-mesa \
    libglu1-mesa-dev libgomp1 libgraphite2-3 libharfbuzz-dev \
    libharfbuzz-gobject0 libharfbuzz-icu0 libharfbuzz0b libhtml-form-perl \
    libhtml-format-perl libhtml-parser-perl libhtml-tagset-perl \
    libhtml-tree-perl libhttp-cookies-perl libhttp-daemon-perl libhttp-date-perl \
    libhttp-message-perl libhttp-negotiate-perl libice-dev libice6 \
    libio-html-perl libio-socket-ssl-perl libisc-export160 libisl15 libitm1 \
    libjson-c2 libjsoncpp1 libllvm6.0 liblsan0 libltdl-dev libltdl7 \
    liblwp-mediatypes-perl liblwp-protocol-https-perl liblzo2-2 \
    libmailtools-perl libmirclient-dev libmirclient9 libmircommon-dev \
    libmircommon7 libmircookie-dev libmircookie2 libmircore-dev libmircore1 \
    libmirprotobuf3 libmnl0 libmp3lame-dev libmp3lame0 libmpc3 libmpfr4 libmpx0 \
    libnet-http-perl libnet-smtp-ssl-perl libnet-ssleay-perl libnuma-dev \
    libnuma1 libogg-dev libogg0 libopus-dev libopus0 libpciaccess0 libpcre16-3 \
    libpcre3-dev libpcre32-3 libpcrecpp0v5 libperl5.22 libpng12-0 libpng12-dev \
    libpopt0 libprotobuf-dev libprotobuf-lite9v5 libprotobuf9v5 \
    libpthread-stubs0-dev libpulse-dev libpulse-mainloop-glib0 libpulse0 \
    libquadmath0 libsdl2-2.0-0 libsdl2-dev libsensors4 libset-scalar-perl \
    libsigsegv2 libsm-dev libsm6 libsndfile1 libsndio-dev libsndio6.1 \
    libstdc++-5-dev libtext-unidecode-perl libtimedate-perl libtool libtsan0 \
    libtxc-dxtn-s2tc0 libubsan0 libudev-dev liburi-perl libva-dev libva-drm1 \
    libva-egl1 libva-glx1 libva-tpi1 libva-wayland1 libva-x11-1 libva1 \
    libvdpau-dev libvdpau1 libvorbis-dev libvorbis0a libvorbisenc2 \
    libvorbisfile3 libvpx-dev libvpx3 libwayland-bin libwayland-client0 \
    libwayland-cursor0 libwayland-dev libwayland-egl1-mesa libwayland-server0 \
    libwrap0 libwww-perl libwww-robotrules-perl libx11-dev libx11-doc \
    libx11-xcb-dev libx11-xcb1 libx264-148 libx264-dev libx265-79 libx265-dev \
    libxau-dev libxcb-dri2-0 libxcb-dri2-0-dev libxcb-dri3-0 libxcb-dri3-dev \
    libxcb-glx0 libxcb-glx0-dev libxcb-present-dev libxcb-present0 libxcb-randr0 \
    libxcb-randr0-dev libxcb-render0 libxcb-render0-dev libxcb-shape0 \
    libxcb-shape0-dev libxcb-shm0 libxcb-shm0-dev libxcb-sync-dev libxcb-sync1 \
    libxcb-xfixes0 libxcb-xfixes0-dev libxcb1-dev libxcursor-dev libxcursor1 \
    libxdamage-dev libxdamage1 libxdmcp-dev libxext-dev libxext6 libxfixes-dev \
    libxfixes3 libxi-dev libxi6 libxinerama-dev libxinerama1 libxkbcommon-dev \
    libxkbcommon0 libxml-libxml-perl libxml-namespacesupport-perl \
    libxml-parser-perl libxml-sax-base-perl libxml-sax-expat-perl \
    libxml-sax-perl libxmuu1 libxrandr-dev libxrandr2 libxrender-dev libxrender1 \
    libxshmfence-dev libxshmfence1 libxss-dev libxss1 libxt-dev libxt6 \
    libxtables11 libxv-dev libxv1 libxxf86vm-dev libxxf86vm1 linux-libc-dev m4 \
    make manpages manpages-dev mesa-common-dev mesa-va-drivers \
    mesa-vdpau-drivers netbase openssh-client patch perl perl-modules-5.22 \
    pkg-config rename rsync tcpd tex-common texinfo ucf va-driver-all \
    vdpau-driver-all wget x11-common x11proto-core-dev x11proto-damage-dev \
    x11proto-dri2-dev x11proto-fixes-dev x11proto-gl-dev x11proto-input-dev \
    x11proto-kb-dev x11proto-randr-dev x11proto-render-dev \
    x11proto-scrnsaver-dev x11proto-video-dev x11proto-xext-dev \
    x11proto-xf86vidmode-dev x11proto-xinerama-dev xauth xkb-data \
    xorg-sgml-doctools xtrans-dev xz-utils yasm zlib1g-dev && \
  apt-get clean && \
  cp -v /root/bin/* /usr/bin/ && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/ffmpeg_build /root/src /root/bin

COPY ffmpegvalidator /scripts/ffmpegvalidator
RUN chmod +x /scripts/ffmpegvalidator
