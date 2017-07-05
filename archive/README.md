# archive

For now you can process the log offline.

Check out and build the music-archive archive-app and copy the 
contents of archive-app/dist to ../nginx/html/1/archive/

See also...

```
git clone https://github.com/cgreenhalgh/music-archive
sudo docker build -t archive .
sudo docker run --name archive -d --network internal \
  -v `pwd`/music-archive:/srv/archive archive
sudo docker exec -it archive bash

node lib/processlogs.js test/data/example_entity_list.json test/data/20170608T112725862Z-default.log 'test/data/Climb!June8.csv'
```

