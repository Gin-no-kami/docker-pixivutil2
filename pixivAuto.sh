#!/bin/bash
umask 000

inter=false
while getopts ":i" o; do
    case "${o}" in
        i)
            inter=true
            ;;
    esac
done

# Check if .active file exists
if [ ! -f /temp/.active ]; then
    # .active file doesn't exist, start pixivutil
    if [ "$inter" == true ]; then
        bash /pixivRun.sh -i
    else
        bash /pixivRun.sh &
    fi
else
    echo "Previous instance still active - not starting new one"
fi
