# docker-pixivutil2
Docker image to automate archival of Pixiv user's galleries using PixivUtil2. This container uses cron to run PixivUtil2 every 6 hours on a list of Pixiv users.

## Application Setup
Create an interactive session using:
```docker exec -u pixivUser -it PixivUtil2 bash```
### Existing PixivUtil2 Migration
If you already have an existing config from an existing PixivUtil2 instance, simply copy the following files:
| Original File | After Copy |
| :----: | --- |
| `config.ini` | `/config/configauto.ini` |
| `db.sqlite` | `/config/db.sqlite` |

Update your config so that it is saving the files to somewhere in `/storage`.

Then in an interactive session generate `member_list.txt` by running `python /opt/PixivUtil2/PixivUtil2.py -c /config/configauto.ini` then options `d`, `3`, `member_list.txt`, `n`.

### New PixivUtil2
In an interactive session run `python /opt/PixivUtil2/PixivUtil2.py` from the `/config` folder and it will generate a `config.ini` for you. Then simply rename it to `configauto.ini`. Checkout [PixivUtil2 documentation](https://github.com/Nandaka/PixivUtil2) for an explination of each option.

### Intended Workflow
Update the following options in your config file:
```
rootDirectory = /storage/
checkUpdatedLimit = 5
```
These options will save the images in the correct location and stop processing a given user if the first 5 images have already been archived.

`member_list.txt` is the file that pixivAuto.sh uses to automatically download all new files from the artists you want. To add new artists to the list, first download their current gallery using the following bash script (to ensure umask is set properly):
```
#!/bin/bash
umask 000
python /opt/PixivUtil2/PixivUtil2.py -c /config/configauto.ini
```
Using option `1` to download by member_id. Then re-generate your member_list.txt by using the commands above. If you need to delete a member_id use options `d` then `9` and then re-generate your member_list.txt.

## Docker Parameters
The following parameters are required:
| Parameter | Function |
| :----: | --- |
| `-v /config` | Configuration files. |
| `-v /storage` | Location used for downloaded images. |

In order to play nicely with Unraid's file permissions, PixivUtil2 is run as the user pixuvUser with PUID 99 and GPID 100 with a 000 mask. These are hardcoded values used in the Dockerfile when the account is created, but I would welcome a merge-request to make this user specified.

## Build and Deploy Steps:
```
sudo systemctl start docker.service
sudo docker build -t ginnokami/pixivutil2:latest .
sudo docker tag BUILDID ginnokami/pixivutil2:VERSION
sudo docker push ginnokami/pixivutil2:latest
sudo docker push ginnokami/pixivutil2:VERSION
```
