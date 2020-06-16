# Into the Depths

Unity server.

Build as `linux server` (makes `linux server.x86_64`); 
copy all generated files into `bin/`
```
sudo docker build -t intothedepths --network=internal .
```
```
sudo docker run -d --restart=always --network=internal \
  --name=intothedepths -p 7778:7778 intothedepths
```

