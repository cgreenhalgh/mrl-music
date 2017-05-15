FROM nginx:1.13.0-alpine

MAINTAINER Chris Greenhalgh "chris.greenhalgh@nottingham.ac.uk"

COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx.vh.default.conf /etc/nginx/conf.d/default.conf
VOLUME /usr/share/nginx/html
VOLUME /var/log/nginx/log
