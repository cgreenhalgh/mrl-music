# Muzivisuals

This is the dynamic programme guide for Climb!

```
git clone https://github.com/littlebugivy/muzivisual.git
```
or
```
git clone https://github.com/cgreenhalgh/muzivisual.git
```
```
sudo docker build -t visuals .
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

