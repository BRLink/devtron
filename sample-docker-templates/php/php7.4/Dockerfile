FROM ubuntu:20.04@sha256:0e0402cd13f68137edb0266e1d2c682f217814420f2d43d300ed8f65479b14fb

RUN apt-get update
RUN apt-get -y upgrade

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --fix-missing php7.4 \
      php7.4-cli \
      php-fpm \
      php7.4-mysql \
      php7.4-curl \
      net-tools

RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y nginx-full
ADD nginx-site.conf /etc/nginx/sites-available/default

WORKDIR /var/www/html/

RUN mkdir -p /run/php

COPY . /var/www/html

EXPOSE 80

CMD ["/bin/bash", "-c", "service php7.4-fpm start && nginx -g \"daemon off;\""]