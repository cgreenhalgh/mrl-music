FROM nginx:1.13.0-alpine

MAINTAINER Chris Greenhalgh "chris.greenhalgh@nottingham.ac.uk"

COPY nginx.conf /etc/nginx/nginx.conf
ADD conf.d/*.conf /etc/nginx/conf.d/
ADD cert/*.crt cert/*.key /etc/nginx/
VOLUME /usr/share/nginx/html
VOLUME /var/log/nginx/log
EXPOSE 443
