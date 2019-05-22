FROM ubuntu:bionic as builder
  COPY build /root/build/
  RUN chmod +x /root/build/*.sh && mkdir -p /root/src /root/bin
  RUN /root/build/packages.sh
  RUN /root/build/nasm.sh
  RUN /root/build/aom.sh
  RUN /root/build/ffmpeg.sh

FROM linuxserver/sabnzbd:latest
LABEL maintainer "T Koopman"

COPY --from=builder /root/bin/* /usr/bin/
COPY --from=builder /root/packages /root/packages
COPY ffmpegvalidator /scripts/ffmpegvalidator

RUN chmod +x /scripts/ffmpegvalidator && \
    apt-get update && \
    apt-get install -y `cat /root/packages` && \
    rm -f /root/packages && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    /usr/bin/ffmpeg -version
