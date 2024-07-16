#!/bin/bash
umask 000

# Set args
if [ -z "$ARGS" ]; then
ARGS='-s 4 -f /config/member_list.txt'
fi
args=( $ARGS )

inter=false
while getopts ":i" o; do
    case "${o}" in
        i)
            inter=true
            ;;
    esac
done


touch /temp/.active
if [ "$inter" == true ]; then
    echo "Running: 'python /opt/PixivUtil2/PixivUtil2.py -c /config/config.ini'"
    python /opt/PixivUtil2/PixivUtil2.py -c /config/config.ini
else
    echo "Running: 'python /opt/PixivUtil2/PixivUtil2.py -c /config/config.ini -x ${args[@]}'"
    python /opt/PixivUtil2/PixivUtil2.py -c /config/config.ini -x ${args[@]}
fi
rm /temp/.active
