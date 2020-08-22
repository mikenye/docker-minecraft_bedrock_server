#!/usr/bin/env bash

REPO=mikenye
IMAGE=minecraft_bedrock_server
PLATFORMS="linux/amd64"

docker context use x86_64
export DOCKER_CLI_EXPERIMENTAL="enabled"
docker buildx use homecluster

# Build the latest image using buildx
docker buildx build --no-cache -t "${REPO}/${IMAGE}:latest" --compress --push --platform "${PLATFORMS}" .

# Get version of latest
docker pull "${REPO}/${IMAGE}:latest"
VERSION=$(docker run --rm --entrypoint cat "${REPO}/${IMAGE}:latest" /MINECRAFT_VERSION)

# Build the version-specific image using buildx
docker buildx build -t "${REPO}/${IMAGE}:${VERSION}" --compress --push --platform "${PLATFORMS}" .
