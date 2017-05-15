#!/bin/sh

sudo apt-get update
sudo apt-get install -y git

# https://docs.docker.com/engine/installation/linux/ubuntu/
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# check fingerprint
sudo apt-key fingerprint 0EBFCD88
echo "should be 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88"
#
#pub   4096R/0EBFCD88 2017-02-22
#      Key fingerprint = 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
#uid                  Docker Release (CE deb) <docker@docker.com>
#sub   4096R/F273FCD8 2017-02-22
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update

sudo apt-get install -y docker-ce=17.03.1~ce-0~ubuntu-xenial
sudo systemctl enable docker
# sudo systemctl disable docker
# sudo docker run hello-world

cd nginx

# self-signed cert
[ -d foo ] || mkdir cert
openssl req \
       -newkey rsa:2048 -nodes -keyout cert/localhost.key \
       -out cert/localhost.csr
openssl x509 \
       -signkey cert/localhost.key \
       -in cert/localhost.csr \
       -req -days 365 -out cert/localhost.crt

sudo docker build -t frontend .

sudo docker run --name frontend -d --restart=always -p :80:80 -p :443:443 -v `pwd`/html:/usr/share/nginx/html -v `pwd`/../logs/nginx:/var/log/nginx/log frontend

