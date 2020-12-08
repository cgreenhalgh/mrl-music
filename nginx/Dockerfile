FROM nginx:1.13.0-alpine

MAINTAINER Chris Greenhalgh "chris.greenhalgh@nottingham.ac.uk"

COPY nginx.conf /etc/nginx/nginx.conf
VOLUME /etc/nginx/conf.d
#ADD conf.d/*.conf /etc/nginx/conf.d/
VOLUME /etc/nginx/cert
#ADD cert/*.crt cert/*.key cert/*.enckey *.pass /etc/nginx/
VOLUME /usr/share/nginx/html
VOLUME /var/log/nginx/log
VOLUME /etc/nginx/conf.d
EXPOSE 443
