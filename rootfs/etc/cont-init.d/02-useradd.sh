#!/usr/bin/with-contenv bash
# shellcheck shell=bash

# Delete user/group if they exist
userdel minecraft > /dev/null 2>&1 || true
groupdel minecraft > /dev/null 2>&1 || true

# Create user/group with specified UID/GID
echo "Creating group 'minecraft' with GID: $PGID"
groupadd --gid $PGID --system minecraft
echo "Creating user 'minecraft' with UID: $PUID"
useradd --home-dir /opt/minecraft --gid $PGID --no-create-home --no-user-group --system --uid $PUID minecraft
