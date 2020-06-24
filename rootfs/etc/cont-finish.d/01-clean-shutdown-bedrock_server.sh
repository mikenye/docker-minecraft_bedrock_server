#!/usr/bin/with-contenv bash
# shellcheck shell=bash

# Check if bedrock_server is running, if so shutdown cleanly
pgrep bedrock_server > /dev/null 2>&1
if [ "$?" -eq "0" ]; then

    /usr/local/bin/sendcmd stop

    EXITCODE=0
    until [ "$EXITCODE" -eq "1" ]; do
        echo "Waiting for bedrock_server to cleanly shutdown..."
        pgrep bedrock_server > /dev/null 2>&1 
        EXITCODE=$?
        sleep 1
    done

    echo "bedrock_server shut down OK."

fi