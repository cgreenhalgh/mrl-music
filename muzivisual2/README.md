# Muzivisuals

This is the dynamic programme guide for Climb!

## Version 2 (August 2017)

```
git clone https://github.com/cgreenhalgh/muzivisual.git
```
(from littlebugivy/muzivisual)

```
sudo docker build -t visual2 .
```

test/dev - see ../scripts/install.sh for regular running
```
sudo docker run --network=internal --name=visual2 \
  --rm -v `pwd`/../logs/muzivisual2:/srv/muzivisual/app/logs \
  -e REDIS_HOST=store -e REDIS_PASSWORD=`cat ../redis/redis.password` \
  -d -v`pwd`/muzivisual/app/data:/srv/muzivisual/app/data visual2
```

In redis, for test/first/second performances:
```
sudo docker exec -it store sh
redis-cli
```
```
auth ...
keys performance:*
del performance:9333e7a2-16a9-4352-a45a-f6f42d848cde
del performance:be418821-436d-41c2-880c-058dffb57d91
del performance:13a7fa70-ae91-4541-9526-fd3b332b585d
```

Or fake history:
```
del performance:20180119-allyourbass1
rpush performance:20180119-allyourbass1 "{\"name\":\"vStart\",\"time\":1496931204243,\"data\":\"20180119-allyourbass1:basecamp\"}"
rpush performance:20180119-allyourbass1 "{\"name\":\"vStageChange\",\"time\":1496931265658,\"data\":\"20180119-allyourbass1:basecamp->1b\"}"
rpush performance:20180119-allyourbass1 "{\"name\":\"vStageChange\",\"time\":1496931265658,\"data\":\"20180119-allyourbass1:1b->p2a\"}"
rpush performance:20180119-allyourbass1 "{\"name\":\"vStageChange\",\"time\":1496931368666,\"data\":\"20180119-allyourbass1:p2a->2b\"}"
rpush performance:20180119-allyourbass1 "{\"name\":\"vStageChange\",\"time\":1496931511498,\"data\":\"20180119-allyourbass1:2b->1a\"}"
rpush performance:20180119-allyourbass1 "{\"name\":\"vStageChange\",\"time\":1496931542159,\"data\":\"20180119-allyourbass1:1a->p1a\"}"
rpush performance:20180119-allyourbass1 "{\"name\":\"vStageChange\",\"time\":1496931641827,\"data\":\"20180119-allyourbass1:p1a->2a\"}"
rpush performance:20180119-allyourbass1 "{\"name\":\"vStageChange\",\"time\":1496931724479,\"data\":\"20180119-allyourbass1:2a->p1b\"}"
rpush performance:20180119-allyourbass1 "{\"name\":\"vStageChange\",\"time\":1496931798689,\"data\":\"20180119-allyourbass1:p1b->3a\"}"
rpush performance:20180119-allyourbass1 "{\"name\":\"vStageChange\",\"time\":1496931894551,\"data\":\"20180119-allyourbass1:3a->p1c\"}"
rpush performance:20180119-allyourbass1 "{\"name\":\"vStageChange\",\"time\":1496931938209,\"data\":\"20180119-allyourbass1:p1c->4a\"}"
rpush performance:20180119-allyourbass1 "{\"name\":\"vStageChange\",\"time\":1496932047204,\"data\":\"20180119-allyourbass1:4a->5a\"}"
rpush performance:20180119-allyourbass1 "{\"name\":\"vStageChange\",\"time\":1496932162161,\"data\":\"20180119-allyourbass1:5a->4b\"}"
rpush performance:20180119-allyourbass1 "{\"name\":\"vStageChange\",\"time\":1496932257265,\"data\":\"20180119-allyourbass1:4b->5b\"}"
rpush performance:20180119-allyourbass1 "{\"name\":\"vStageChange\",\"time\":1496932332282,\"data\":\"20180119-allyourbass1:5b->summit\"}"
rpush performance:20180119-allyourbass1 "{\"name\":\"vStop\",\"time\":1496932471571,\"data\":\"20180119-allyourbass1\"}"
del performance:20180119-allyourbass2
rpush performance:20180119-allyourbass2 "{\"name\":\"vStart\",\"time\":1496931204243,\"data\":\"20180119-allyourbass2:basecamp\"}"
```

## Dump performances (history)
```
sudo docker exec visual2 redis-dump -a `cat ../redis/redis.password` \
 -h store --json 'performance:*' > performances.json
```

