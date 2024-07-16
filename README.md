# docker-pixivutil2
Docker image to automate archival of Pixiv user's galleries using PixivUtil2. This container uses cron to run PixivUtil2 every 6 hours on a list of Pixiv users.

## Application Setup
Create an interactive session using:
```docker exec -u pixivUser -it PixivUtil2 bash```
### Existing PixivUtil2 Migration
If you already have an existing config from an existing PixivUtil2 instance, simply copy the following files:
| Original File | After Copy |
| :----: | --- |
| `config.ini` | `/config/config.ini` |
| `db.sqlite` | `/config/db.sqlite` |

Update your config so that it is saving the files to somewhere in `/storage`.

Then in an interactive session generate `member_list.txt` by running `cd /config && /opt/PixivUtil2/PixivUtil2.py -c /config/config.ini` then options `d`, `3`, `member_list.txt`, `n`.

### New PixivUtil2
Running the container for the first time will create a config.ini in the `/config` folder then exit. Configure the file as needed. Checkout [PixivUtil2 documentation](https://github.com/Nandaka/PixivUtil2) for an explination of each option. You will need to follow the authentication instructions [here](https://github.com/Nandaka/PixivUtil2/tree/master?tab=readme-ov-file#a-usage) at a minimum.

## Configuration
The container takes 2 environment variables for the auto run:
| ENV Variable | Type |Default | Explanation |
| :---: | --- | --- | --- |
| `ARGS` | string | -s 4 -f /config/member_list.txt -x | The content of this variable with be appended<br>to the command that starts PixivUtil |
| `CRON` | string | 0 */6 * * * | The cron entry for how often PixivUtil2 should be started, defaulted to every 6 hours.<br>Mind you that a new instance will never start if the previous run is still active.<br>So technically this can be considered<br>"How often to try starting a new instance once the previous one finished".

## Docker Parameters
The following parameters are required:
| Parameter | Function |
| :----: | --- |
| `-v /config` | Configuration files. |
| `-v /storage` | Location used for downloaded images. |

In order to play nicely with Unraid's file permissions, PixivUtil2 is run as the user pixuvUser with PUID 99 and GPID 100 with a 000 mask. These are hardcoded values used in the Dockerfile when the account is created, but I would welcome a merge-request to make this user specified.

## Running
The container automatically all new images from the `member_list.txt` on a set time based on the `CRON` variable. You can get an interactive session (with the same config/options) by running '/pixivRun.sh'.

## Build and Deploy Steps:
```
sudo systemctl start docker.service
sudo docker build -t ginnokami/pixivutil2:latest .
sudo docker tag BUILDID ginnokami/pixivutil2:VERSION
sudo docker push ginnokami/pixivutil2:latest
sudo docker push ginnokami/pixivutil2:VERSION
```
