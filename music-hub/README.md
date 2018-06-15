# Music Hub

```
git clone https://github.com/cgreenhalgh/music-hub.git
```

See[music-hub/README.md](music-hub/README.md).

Requires mysql server (hubdb by default)

E.g.
```
cd music-hub
docker build -t music-hub -f Dockerfile.musichub .
cd ..
```

dev/test
```
sudo docker run -it --rm -p 8000:8000 -p 4200:4200 -p 9876:9876 \
 --network=internal -e MUSICHUB_PASSWORD=`cat musichub.password` \
 -e REDIS_PASSWORD=`cat ../redis/redis.password` \
 -e LOGPROC_PASSWORD=`cat ../archive/logproc.password` \
 -v `pwd`/../data/muzivisual2:/root/work/mounts/climbapp/muzivisual2 \
 -v `pwd`/../html/1/archive/assets/data:/root/work/mounts/climbapp/archive \
 -v `pwd`/../html/1/recordings:/root/work/mounts/uploads \
 --name musichub music-hub /bin/bash
```
```
cd server/
`npm bin`/tsc
node dist/index.js

cd hub-app
`npm bin`/ng build --bh /2/musichub/
```

