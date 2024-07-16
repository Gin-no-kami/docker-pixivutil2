#!/bin/bash
umask 000

# Set args
if [ -z "$ARGS" ]; then
ARGS='-s 4 -f /config/member_list.txt'
fi
args=( $ARGS )

echo "Running: 'python /opt/PixivUtil2/PixivUtil2.py -c /config/config.ini -x ${args[@]}'"
touch /temp/.active
python /opt/PixivUtil2/PixivUtil2.py -c /config/config.ini -x ${args[@]}
rm /temp/.active
