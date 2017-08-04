# archive

For now you can process the log offline.

Check out and build the music-archive archive-app and copy the 
contents of archive-app/dist to ../nginx/html/1/archive/

See also...

```
git clone https://github.com/cgreenhalgh/music-archive
cd music-archive/logproc
sudo docker build -t logproc .
cd ../..
sudo docker run --name logproc -d --network internal \
  -v `pwd`/../html/1/archive/assets/data:/srv/archive/output \
  -v `pwd`/../logs/logproc:/srv/archive/logs logproc
```
or maybe
```
sudo docker exec -it archive bash

node lib/processlogs.js test/data/example_entity_list.json test/data/20170608T112725862Z-default.log 'test/data/Climb!June8.csv'
```

