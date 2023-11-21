FROM alpine:latest AS runtime-base

RUN apk add --no-cache wget unzip cmake make g++ glib-dev python3-dev openjdk8-jre openjdk8 byobu bash

# set the Kernel UDP buffer size to 10MB
RUN echo 'net.core.rmem_max=10485760' >> /etc/sysctl.conf
RUN echo 'net.core.rmem_default=10485760' >> /etc/sysctl.conf

RUN apk add --no-cache --update musl musl-utils musl-locales tzdata
ENV TZ=Europe/London
RUN cp /usr/share/zoneinfo/Europe/London /etc/localtime

ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB:en
ENV LC_ALL en_GB.UTF-8

FROM runtime-base AS build

ENV LCM_VERSION '1.5.0'

# install LCM
RUN \
    # pull lcm
    wget https://github.com/lcm-proj/lcm/archive/refs/tags/v$LCM_VERSION.zip && \
    # open up the source
    unzip v$LCM_VERSION.zip && \
    # configure, build, install, and configure LCM
    cd lcm-$LCM_VERSION && mkdir build && cd build && cmake ../ && make -j install

# delete source code
RUN cd / && rm -rf v$LCM_VERSION.zip lcm-$LCM_VERSION

# configure pkgconfig to find LCM
ENV PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$LCM_INSTALL_DIR/pkgconfig

