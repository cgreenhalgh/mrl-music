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

cd redis

# random redis password
< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32} > redis.password
sed -e "s/PASSWORD/`cat redis.password`/" redis.conf.template > redis.conf

sudo docker build -t store .

sudo docker run --name store -d --restart=always --network=internal \
  -p :6379:6379 store


cd ../muzivisual1

[-d muzivisual] || git clone https://github.com/cgreenhalgh/muzivisual; git checkout v1

sudo docker build -t visual1 .

sudo docker run \
--network=internal --name=visual1 -d --restart=always \
-e REDIS_HOST=store -e REDIS_PASSWORD=`cat ../redis/redis.password` \
visual1

cd ../muzivisual2

[-d muzivisual] || git clone https://github.com/cgreenhalgh/muzivisual

# fix base href in web app
sed -i -e 'sX<base href="/">X<base href="/2/muzivisual/">X' muzivisual/app/public/index.html

sudo docker build -t visual2 .

sudo docker run \
--network=internal --name=visual2 -d --restart=always \
-v `pwd`/../logs/muzivisual2:/srv/muzivisual/app/logs \
-v `pwd`/../data/muzivisual2:/srv/muzivisual/app/data \
-e REDIS_HOST=store -e REDIS_PASSWORD=`cat ../redis/redis.password` \
visual2


cd ../archive

[-d music-archive] || git clone https://github.com/cgreenhalgh/music-archive

cd music-archive/archive-app

sudo docker build -t archive-app .
sudo docker run --rm archive-app cat /root/work/archive.tgz| cat - > ../../archive.tgz
#sudo docker run --rm archive-app cat /root/work/package-lock.json |  cat - > package-lock.json
cd ../..

(cd ../html/1/archive; tar zxf ../../../archive/archive.tgz)

# muzivisual for use with archive
mkdir ../html/1/archive-muzivisual
[-d muzivisual] || git clone https://github.com/cgreenhalgh/muzivisual && (cd muzivisual; git checkout linkapps)
#sed -i -e 'sX<base href="/">X<base href="/1/archive-muzivisual/">X' muzivisual/app/public/index.html
#sudo docker build -f Dockerfile.muzivisual -t archive-muzivisual .
#sudo docker run --rm archive-muzivisual

(cd muzivisual/app/public; tar zcf - *) | (cd ../html/1/archive-muzivisual; tar zxf -)


< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32} > logproc.password
sed -e "s/PASSWORD/`cat logproc.password`/" music-archive/logproc/etc/server-config.yml.template > music-archive/logproc/etc/server-config.yml

cd music-archive/logproc

# NB archive must be installed in html/1/archive/ before logproc will start properly

sudo docker build -t logproc .
cd ../..
sudo docker run --name logproc -d --restart=always \
  --network internal \
  -v `pwd`/../html/1/archive/assets/data:/srv/archive/output \
  -v `pwd`/../logs/logproc:/srv/archive/logs logproc

# music-hub - mysql
cd ../music-hub

[-d music-hub] || git clone https://github.com/cgreenhalgh/music-hub

< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32} > hubdb.password
sudo docker run --name hubdb -e MYSQL_ROOT_PASSWORD=`cat hubdb.password` --network=internal -d --restart=always mysql:5.7

< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32} > musichub.password
< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32} > hubadmin.password
sed -e "s/MUSICHUB_PASSWORD/`cat musichub.password`/;s/HUBADMIN_PASSWORD/`cat hubadmin.password`/" music-hub/createdb.sql.template > music-hub/createdb.sql


# init db
cat music-hub/createdb.sql | sudo docker run -i --rm --network=internal mysql:5.7 sh -c "exec mysql -hhubdb -P3306 -uroot -p`cat hubdb.password`"

cd music-hub
sudo docker build -t music-hub -f Dockerfile.musichub .
cd ..

sudo docker run --name=musichub -d -p 8000:8000 \
 --network=internal -e MUSICHUB_PASSWORD=`cat musichub.password` \
 -e REDIS_PASSWORD=`cat ../redis/redis.password` \
 -e LOGPROC_PASSWORD=`cat ../archive/logproc.password` \
 -v `pwd`/../data/muzivisual2:/root/work/mounts/climbapp/muzivisual2 \
 -v `pwd`/../html/1/archive/assets/data:/root/work/mounts/climbapp/archive \
 -v `pwd`/../html/1/recordings:/root/work/mounts/uploads \
 --restart=always music-hub
echo "login as root@musichub password `cat hubadmin.password`"

# losing-her-voice
[-d losing-her-voice] || git clone https://github.com/cgreenhalgh/losing-her-voice
# audience-app - version built & committed
mkdir -p html/2
(cd losing-her-voice/html/2; tar zcf - losing-her-voice) | (cd html/2; tar zxf -)

# audience-server
cd losing-her-voice
sudo docker build -t audience-server --network=internal audience-server
cd ..

sudo mkdir -p logs/audience-server
sudo docker run -d --name=audience-server --restart=always \
  --network=internal -p :8081:8081 \
  -v `pwd`/losing-her-voice/audience-server/data:/root/work/data/ \
  -v `pwd`/logs/audience-server:/root/work/logs/ \
  -e REDIS_HOST=store -e REDIS_PASSWORD=`cat redis/redis.password` \
  audience-server

# general logging
cd ../logging
[-d http-logging-service] || \
  git clone https://github.com/cgreenhalgh/http-logging-service

cd http-logging-service
sudo docker build -t logging-server --network=internal  server
cd ..

# juan...
< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32} > strap.password
mkdir -p conf
sed -e "s/STRAP_PASSWORD/`cat strap.password`/;" \
  strap.json.template > conf/strap.json
sudo mkdir -p ../logs/loglevel/strap

# themoment
< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32} > themoment.password
sed -e "s/STRAP_PASSWORD/`cat themoment.password`/;" \
  strap.json.template > conf/themoment.json
sudo mkdir -p ../logs/loglevel/themoment

cd ..

# start...
sudo docker run -d -p 8080:8080 --name=logging-server \
 --restart=always \
 -v `pwd`/logging/conf:/go/src/app/conf \
 -v `pwd`/logs/loglevel:/go/src/app/logs \
 --network=internal \
 logging-server


cd nginx

# self-signed cert
[ -d cert ] || mkdir cert
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
  -v `pwd`/conf.d:/etc/nginx/conf.d \
  -v `pwd`/../logs/nginx:/var/log/nginx/log frontend 

# firewall
#sudo iptables -L DOCKER --line-numbers
# interface, e.g. eth0
#sudo iptables -I DOCKER -i enp0s3 -p tcp --dport 6379 ! -s 128.243.22.74 -j DROP
# vagrant host IP 10.0.2.2
#sudo iptables -I DOCKER -i enp0s3 -p tcp --dport 6379 ! -s 10.0.2.2 -j DROP
# sudo iptables -D DOCKER 1

