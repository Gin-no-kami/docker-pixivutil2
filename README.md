# docker-pixivutil2

Steps to update:

sudo systemctl start docker.service
sudo docker build -t ginnokami/pixivutil2:latest .
sudo docker tag BUILDID ginnokami/pixivutil2:VERSION
sudo docker push ginnokami/pixivutil2:latest
sudo docker push ginnokami/pixivutil2:VERSION