#!/usr/bin/with-contenv bash
# shellcheck shell=bash

# Switch to light blue
echo -ne '\033[1;34m'
echo ""
cat /opt/minecraft/release-notes.txt
echo ""
echo -ne '\033[0m'