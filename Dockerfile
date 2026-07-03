FROM golang:1.26-trixie AS mc-monitor-builder

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Get & build mc-monitor
RUN git clone https://github.com/itzg/mc-monitor.git /src/mc-monitor
RUN pushd /src/mc-monitor && \
    go mod tidy
RUN pushd /src/mc-monitor && \
    go build
RUN cp -v /src/mc-monitor/mc-monitor /usr/local/bin
RUN /usr/local/bin/mc-monitor -h

FROM debian:trixie

ARG S6_OVERLAY_VERSION=3.2.3.0

ENV PUID=1000 \
    PGID=1000 \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    BACKUP_FREQUENCY=1 \
    BACKUP_RETENTION=24

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY --from=mc-monitor-builder /usr/local/bin/mc-monitor /usr/local/bin/mc-monitor

RUN set -x && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      file \
      gawk \
      gnupg2 \
      libcurl4 \
      procps \
      tmux \
      unzip \
      xz-utils \
      wget \
      && \
    MINECRAFT_LINUX_SERVER_URL="https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-1.26.32.2.zip" && \
    # Download bedrock server
    mkdir -p /src && \
    wget -O /src/bedrock-server.zip "$MINECRAFT_LINUX_SERVER_URL" && \
    # Unpack minecraft server
    mkdir -p /opt/minecraft && \
    unzip /src/bedrock-server.zip -d /opt/minecraft && \
    mkdir -p /opt/minecraft/worlds_backup && \
    touch /opt/minecraft/worlds_backup/.placeholder && \
    # Move & link allowlist
    mkdir -p /opt/minecraft/allowlist && \
    touch /opt/minecraft/allowlist.json && \
    mv -v /opt/minecraft/allowlist.json /opt/minecraft/allowlist/allowlist.json && \
    ln -s /opt/minecraft/allowlist/allowlist.json /opt/minecraft/allowlist.json && \
    # Move & link permissions
    mkdir -p /opt/minecraft/permissions && \
    touch /opt/minecraft/permissions.json && \
    mv -v /opt/minecraft/permissions.json /opt/minecraft/permissions/permissions.json && \
    ln -s /opt/minecraft/permissions/permissions.json /opt/minecraft/permissions.json && \
    # Clean up
    apt-get remove -y \
      ca-certificates \
      curl \
      file \
      gcc \
      git \
      gnupg2 \
      golang-go \
      libc-dev \
      unzip \
      wget \
      && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /src /tmp/* /var/lib/apt/lists/* && \
    find /var/log -type f -iname "*log" -exec truncate --size 0 {} \; && \
    # Document minecraft version
    pushd /opt/minecraft && \
    chmod a+x ./bedrock_server && \
    LD_LIBRARY_PATH=. timeout 5s ./bedrock_server | awk -F'Version: ' '/Version:/ { print $2; exit }' > /MINECRAFT_VERSION || true && \
    popd && \
    cat /MINECRAFT_VERSION && \
    # If /MINECRAFT_VERSION is empty, then raise an error (should have version inside)
    if [ ! -s /MINECRAFT_VERSION ]; then exit 1; fi

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

COPY /rootfs /

ENTRYPOINT [ "/init" ]

EXPOSE 19132/udp 19133/udp

HEALTHCHECK --start-period=30s CMD /usr/local/bin/mc-monitor status-bedrock
