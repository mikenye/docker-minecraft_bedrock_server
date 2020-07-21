FROM debian:stable-slim

ENV PUID=1000 \
    PGID=1000 \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    BACKUP_FREQUENCY=1 \
    BACKUP_RETENTION=24

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -x && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      file \
      gawk \
      gcc \
      git \
      gnupg2 \
      golang-go \
      libc-dev \
      libcurl4 \
      procps \
      tmux \
      unzip \
      xz-utils \
      && \
    # Get latest server binary
    MINECRAFT_LINUX_SERVER_URL=$(curl "https://www.minecraft.net/en-us/download/server/bedrock/" | grep "serverBedrockLinux" | grep -oE "href=\"https://.*/.*\.zip" | cut -d '"' -f 2) && \
    # Download bedrock server
    mkdir -p /src && \
    curl --location --output /src/bedrock-server.zip "$MINECRAFT_LINUX_SERVER_URL" && \
    # Unpack minecraft server
    mkdir -p /opt/minecraft && \
    unzip /src/bedrock-server.zip -d /opt/minecraft && \
    mkdir -p /opt/minecraft/worlds_backup && \
    touch /opt/minecraft/worlds_backup/.placeholder && \
    # Move & link whitelist
    mkdir -p /opt/minecraft/whitelist && \
    touch /opt/minecraft/whitelist.json && \
    mv -v /opt/minecraft/whitelist.json /opt/minecraft/whitelist/whitelist.json && \
    ln -s /opt/minecraft/whitelist/whitelist.json /opt/minecraft/whitelist.json && \
    # Move & link permissions
    mkdir -p /opt/minecraft/permissions && \
    touch /opt/minecraft/permissions.json && \
    mv -v /opt/minecraft/permissions.json /opt/minecraft/permissions/permissions.json && \
    ln -s /opt/minecraft/permissions/permissions.json /opt/minecraft/permissions.json && \
    # Get mc-status
    git clone https://github.com/itzg/mc-monitor.git /src/mc-monitor && \
    pushd /src/mc-monitor && \
    go get && \
    go build && \
    cp -v mc-monitor /usr/local/bin && \
    popd && \
    # Deploy s6 overlay
    curl -s https://raw.githubusercontent.com/mikenye/deploy-s6-overlay/master/deploy-s6-overlay.sh | sh && \
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
      && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /src /tmp/* /var/lib/apt/lists/* && \
    find /var/log -type f -iname "*log" -exec truncate --size 0 {} \; && \
    # Document minecraft version
    pushd /opt/minecraft && \
    LD_LIBRARY_PATH=. timeout 5s ./bedrock_server | grep -i version | cut -d " " -f 5 > /MINECRAFT_VERSION || true && \
    popd && \
    cat /MINECRAFT_VERSION && \
    # If /MINECRAFT_VERSION is empty, then raise an error (should have version inside)
    if [ ! -s /MINECRAFT_VERSION ]; then exit 1; fi

COPY /rootfs /

ENTRYPOINT [ "/init" ]

EXPOSE 19132/udp 19133/udp

HEALTHCHECK --start-period=30s CMD /usr/local/bin/mc-monitor status-bedrock
