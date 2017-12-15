FROM node:4.8.3

MAINTAINER Chris Greenhalgh "chris.greenhalgh@nottingham.ac.uk"

EXPOSE 8000

COPY muzivisual/package.json /srv/muzivisual/
RUN cd /srv/muzivisual && npm install --production
RUN npm install redis-dump -g

ADD muzivisual/app /srv/muzivisual/app
VOLUME /srv/muzivisual/app/data
RUN test -d /srv/muzivisual/app/logs || mkdir /srv/muzivisual/app/logs
VOLUME /srv/muzivisual/app/logs

ENV REDIS_HOST=localhost
ENV REDIS_PASSWORD=

WORKDIR /srv/muzivisual

CMD [ "node", "app/server.js" ] 
