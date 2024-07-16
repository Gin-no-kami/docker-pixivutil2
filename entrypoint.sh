#!/bin/sh

# Make sure the necessary folders exist
mkdir -p /config
mkdir -p /storage
mkdir -p /temp

# Make sure our user owns the folders
chown pixivUser:users /config /storage /temp

# We are at container startup, so if the .active file from a previous run still exists, delete it
if [ -f /temp/.active ]; then
    rm /temp/.active
fi

# Check if config file already exists, if not, copy over the default configuration file and exit
if [ ! -f /config/config.ini ]; then
    cp /opt/PixivUtil2/default_config.ini /config/config.ini
    chown pixivUser:users /config/config.ini
    echo "Configuration file has been created - please adjust it as fit before starting the container again."
    exit
fi

if [ -z "$CRON" ]; then
    cron="0 */6 * * *"
else
    cron="$CRON"
fi

echo "$cron /pixivAuto.sh" > /crontab.txt
/usr/bin/crontab -u pixivUser /crontab.txt

exec "/cronInit.sh"
