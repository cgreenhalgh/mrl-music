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

sudo docker network create --driver bridge internal


cd ../muzivisual1

[-d muzivisual] || git clone https://github.com/cgreenhalgh/muzivisual; git checkout v1

sudo docker built -t visual1 .

sudo docker run \
--network=internal --name=visual1 -d --restart=always \
-e REDIS_HOST=store -e REDIS_PASSWORD=`cat ../redis/redis.password` \
visual1

cd ../muzivisual2

[-d muzivisual] || git clone https://github.com/cgreenhalgh/muzivisual

sudo docker built -t visual2 .

sudo docker run \
--network=internal --name=visual2 -d --restart=always \
-v `pwd`/../logs/muzivisual2:/srv/muzivisual/app/logs \
-e REDIS_HOST=store -e REDIS_PASSWORD=`cat ../redis/redis.password` \
visual2



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
touch cert/keys.pass

# cp music-mrl/music-mrl.nott.ac.uk.enckey music-mrl.nott.ac.uk.key
# cp music-mrl/music-mrl_nott_ac_uk.crt music-mrl.nott.ac.uk.concat.crt
# cat music-mrl/RootCertificates/QuoVadisOVIntermediateCertificate.crt >> music-mrl.nott.ac.uk.concat.crt
# echo >> music-mrl.nott.ac.uk.concat.crt
# cat music-mrl/RootCertificates/QuoVadisOVRootCertificate.crt  >> music-mrl.nott.ac.uk.concat.crt
# echo XXXX > cert/keys.pass

sudo docker build -t frontend .

sudo docker run --name frontend -d --restart=always --network=internal \
  -p :80:80 -p :443:443 -v `pwd`/../html:/usr/share/nginx/html \
  -v `pwd`/../logs/nginx:/var/log/nginx/log frontend

cd ../redis

# random redis password
< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32} > redis.password
sed -e "s/PASSWORD/`cat redis.password`/" redis.conf.template > redis.conf

sudo docker build -t store .

sudo docker run --name store -d --restart=always --network=internal \
  -p :6379:6379 store

# firewall
#sudo iptables -L DOCKER --line-numbers
# interface, e.g. eth0
#sudo iptables -I DOCKER -i enp0s3 -p tcp --dport 6379 ! -s 128.243.22.74 -j DROP
# vagrant host IP 10.0.2.2
#sudo iptables -I DOCKER -i enp0s3 -p tcp --dport 6379 ! -s 10.0.2.2 -j DROP
# sudo iptables -D DOCKER 1

cd ../annalist

sudo docker pull gklyne/annalist_site
sudo docker pull gklyne/annalist

# one time
sudo docker run --name=annalist_site --detach gklyne/annalist_site
#sudo docker run --interactive --tty --rm \
#    --publish=8000:8000 --volumes-from=annalist_site \
#    gklyne/annalist bash <<!
sudo docker run --interactive --tty --rm \
    --network=internal --name=annalist --volumes-from=annalist_site \
    gklyne/annalist bash
# one time
annalist-manager createsitedata
annalist-manager initialize
# or later
annalist-manager updatesitedata

annalist-manager runserver
!
sudo docker run \
--network=internal --name=annalist --volumes-from=annalist_site \
-d --restart=always gklyne/annalist annalist-manager runserver

cd ../muzivisual

[-d muzivisual] || git clone https://github.com/cgreenhalgh/muzivisual

sudo docker built -t visuals .

sudo docker run \
--network=internal --name=visuals -d --restart=always \
-e REDIS_HOST=store -e REDIS_PASSWORD=`cat ../redis/redis.password` \
visuals


