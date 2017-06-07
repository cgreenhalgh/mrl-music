# archive

```
git clone https://github.com/cgreenhalgh/music-archive
sudo docker build -t archive .
sudo docker run --name archive -d --network internal \
  -v `pwd`/music-archive:/srv/archive archive
sudo docker exec archive bash

```

