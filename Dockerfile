FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# set version label
ARG BUILD_DATE
ARG VERSION
ARG WEBCORD_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=WebCord \
DEBIAN_FRONTEND=noninteractive

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /kclient/public/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/webcord-icon.png && \
  echo "**** install webcord ****" && \
  if [ -z ${WEBCORD_VERSION+x} ]; then \
    WEBCORD_VERSION=$(curl -sX GET "https://api.github.com/repos/SpacingBat3/WebCord/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -o \
    /tmp/webcord.deb -L \
    "https://github.com/SpacingBat3/WebCord/releases/download/${WEBCORD_VERSION}/webcord_$(echo ${WEBCORD_VERSION}| cut -c2-)_amd64.deb" && \
  apt-get update && \
  apt-get install -y /tmp/webcord.deb && \
  apt-get install -y --no-install-recommends \
    chromium \
    chromium-l10n \
    fonts-noto-cjk \
    fonts-noto-color-emoji && \
  echo "**** application tweaks ****" && \
  mv \
    /usr/bin/webcord \
    /usr/bin/webcord-real && \ 
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
