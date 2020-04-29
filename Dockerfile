FROM debian:jessie-slim

RUN apt-get update && apt-get install -y php5-common php5-cli php5-fpm php5-mcrypt php5-mysql php5-apcu php5-gd php5-imagick php5-curl php5-intl php5-pgsql
RUN apt-get install -y php5-memcache php5-memcached

RUN usermod -u 1000 www-data

CMD ["php5-fpm", "-F"]

EXPOSE 9000