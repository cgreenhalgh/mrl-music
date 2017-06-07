FROM node:4.8.3

MAINTAINER Chris Greenhalgh "chris.greenhalgh@nottingham.ac.uk"

EXPOSE 8000

COPY music-archive/package.json /srv/archive/
RUN cd /srv/archive && npm install --production

#ADD music-archive/lib /srv/music-archive/lib
#VOLUME /srv/muzivisual/app/maps
VOLUME /srv/archive 

#ENV REDIS_HOST=localhost
#ENV REDIS_PASSWORD=

WORKDIR /srv/archive

CMD [ "node", "lib/server.js" ] 
