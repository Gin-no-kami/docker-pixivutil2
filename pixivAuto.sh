#!/bin/bash
umask 000

# Check if .active file exists
if [ ! -f /temp/.active ]; then
    # .active file doesn't exist, start pixivutil
    bash /pixivRun.sh &
else
    echo "Previous instance still active - not starting new one"
fi
