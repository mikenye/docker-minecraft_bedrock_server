#!/usr/bin/with-contenv bash
# shellcheck shell=bash

SERVER_PROPERTIES_FILE="/opt/minecraft/server.properties"

if [ ! -z "${MINECRAFT_SERVER_NAME}" ]; then
  search="server-name="
  replace="server-name=${MINECRAFT_SERVER_NAME}"
  sed -i "/${search}/c\\${replace}" "${SERVER_PROPERTIES_FILE}"
fi

if [ ! -z "${MINECRAFT_GAMEMODE}" ]; then
  search="gamemode="
  replace="gamemode=${MINECRAFT_GAMEMODE}"
  sed -i "/${search}/c\\${replace}" "${SERVER_PROPERTIES_FILE}"
fi

if [ ! -z "${MINECRAFT_DIFFICULTY}" ]; then
  search="difficulty="
  replace="difficulty=${MINECRAFT_DIFFICULTY}"
  sed -i "/${search}/c\\${replace}" "${SERVER_PROPERTIES_FILE}"
fi

if [ ! -z "${MINECRAFT_ALLOW_CHEATS}" ]; then
  search="allow-cheats="
  replace="allow-cheats=${MINECRAFT_ALLOW_CHEATS}"
  sed -i "/${search}/c\\${replace}" "${SERVER_PROPERTIES_FILE}"
fi

if [ ! -z "${MINECRAFT_MAX_PLAYERS}" ]; then
  search="max-players="
  replace="max-players=${MINECRAFT_MAX_PLAYERS}"
  sed -i "/${search}/c\\${replace}" "${SERVER_PROPERTIES_FILE}"
fi

if [ ! -z "${MINECRAFT_ONLINE_MODE}" ]; then
  search="online-mode="
  replace="online-mode=${MINECRAFT_ONLINE_MODE}"
  sed -i "/${search}/c\\${replace}" "${SERVER_PROPERTIES_FILE}"
fi

if [ ! -z "${MINECRAFT_WHITE_LIST}" ]; then
  search="white-list="
  replace="white-list=${MINECRAFT_WHITE_LIST}"
  sed -i "/${search}/c\\${replace}" "${SERVER_PROPERTIES_FILE}"
fi

if [ ! -z "${MINECRAFT_SERVER_PORT_IPV4}" ]; then
  search="server-port="
  replace="server-port=${MINECRAFT_SERVER_PORT_IPV4}"
  sed -i "/${search}/c\\${replace}" "${SERVER_PROPERTIES_FILE}"
fi

if [ ! -z "${MINECRAFT_SERVER_PORT_IPV6}" ]; then
  search="server-portv6="
  replace="server-portv6=${MINECRAFT_SERVER_PORT_IPV6}"
  sed -i "/${search}/c\\${replace}" "${SERVER_PROPERTIES_FILE}"
fi

if [ ! -z "${MINECRAFT_VIEW_DISTANCE}" ]; then
  search="view-distance="
  replace="view-distance=${MINECRAFT_VIEW_DISTANCE}"
  sed -i "/${search}/c\\${replace}" "${SERVER_PROPERTIES_FILE}"
fi

if [ ! -z "${MINECRAFT_TICK_DISTANCE}" ]; then
  search="tick-distance="
  replace="tick-distance=${MINECRAFT_TICK_DISTANCE}"
  sed -i "/${search}/c\\${replace}" "${SERVER_PROPERTIES_FILE}"
fi

if [ ! -z "${MINECRAFT_PLAYER_IDLE_TIMEOUT}" ]; then
  search="player-idle-timeout="
  replace="player-idle-timeout=${MINECRAFT_PLAYER_IDLE_TIMEOUT}"
  sed -i "/${search}/c\\${replace}" "${SERVER_PROPERTIES_FILE}"
fi

if [ ! -z "${MINECRAFT_MAX_THREADS}" ]; then
  search="max-threads="
  replace="max-threads=${MINECRAFT_MAX_THREADS}"
  sed -i "/${search}/c\\${replace}" "${SERVER_PROPERTIES_FILE}"
fi

if [ ! -z "${MINECRAFT_LEVEL_NAME}" ]; then
  search="level-name="
  replace="level-name=${MINECRAFT_LEVEL_NAME}"
  sed -i "/${search}/c\\${replace}" "${SERVER_PROPERTIES_FILE}"
fi

if [ ! -z "${MINECRAFT_LEVEL_SEED}" ]; then
  search="level-seed="
  replace="level-seed=${MINECRAFT_LEVEL_SEED}"
  sed -i "/${search}/c\\${replace}" "${SERVER_PROPERTIES_FILE}"
fi

if [ ! -z "${MINECRAFT_DEFAULT_PLAYER_PERMISSION_LEVEL}" ]; then
  search="default-player-permission-level="
  replace="default-player-permission-level=${MINECRAFT_DEFAULT_PLAYER_PERMISSION_LEVEL}"
  sed -i "/${search}/c\\${replace}" "${SERVER_PROPERTIES_FILE}"
fi

if [ ! -z "${MINECRAFT_TEXTUREPACK_REQUIRED}" ]; then
  search="texturepack-required="
  replace="texturepack-required=${MINECRAFT_TEXTUREPACK_REQUIRED}"
  sed -i "/${search}/c\\${replace}" "${SERVER_PROPERTIES_FILE}"
fi

if [ ! -z "${MINECRAFT_CONTENT_LOG_FILE_ENABLED}" ]; then
  search="content-log-file-enabled="
  replace="content-log-file-enabled=${MINECRAFT_CONTENT_LOG_FILE_ENABLED}"
  sed -i "/${search}/c\\${replace}" "${SERVER_PROPERTIES_FILE}"
fi

if [ ! -z "${MINECRAFT_COMPRESSION_THRESHOLD}" ]; then
  search="compression-threshold="
  replace="compression-threshold=${MINECRAFT_COMPRESSION_THRESHOLD}"
  sed -i "/${search}/c\\${replace}" "${SERVER_PROPERTIES_FILE}"
fi

if [ ! -z "${MINECRAFT_SERVER_AUTHORATIVE_MOVEMENT}" ]; then
  search="server-authoritative-movement="
  replace="server-authoritative-movement=${MINECRAFT_SERVER_AUTHORATIVE_MOVEMENT}"
  sed -i "/${search}/c\\${replace}" "${SERVER_PROPERTIES_FILE}"
fi

if [ ! -z "${MINECRAFT_PLAYER_MOVEMENT_SCORE_THRESHOLD}" ]; then
  search="player-movement-score-threshold="
  replace="player-movement-score-threshold=${MINECRAFT_PLAYER_MOVEMENT_SCORE_THRESHOLD}"
  sed -i "/${search}/c\\${replace}" "${SERVER_PROPERTIES_FILE}"
fi

if [ ! -z "${MINECRAFT_PLAYER_MOVEMENT_DISTANCE_THRESHOLD}" ]; then
  search="player-movement-distance-threshold="
  replace="player-movement-distance-threshold=${MINECRAFT_PLAYER_MOVEMENT_DISTANCE_THRESHOLD}"
  sed -i "/${search}/c\\${replace}" "${SERVER_PROPERTIES_FILE}"
fi

if [ ! -z "${MINECRAFT_PLAYER_MOVEMENT_DISTANCE_THRESHOLD_IN_MS}" ]; then
  search="player-movement-duration-threshold-in-ms="
  replace="player-movement-duration-threshold-in-ms=${MINECRAFT_PLAYER_MOVEMENT_DISTANCE_THRESHOLD_IN_MS}"
  sed -i "/${search}/c\\${replace}" "${SERVER_PROPERTIES_FILE}"
fi

if [ ! -z "${MINECRAFT_CORRECT_PLAYER_MOVEMENT}" ]; then
  search="correct-player-movement="
  replace="correct-player-movement=${MINECRAFT_CORRECT_PLAYER_MOVEMENT}"
  sed -i "/${search}/c\\${replace}" "${SERVER_PROPERTIES_FILE}"
fi
