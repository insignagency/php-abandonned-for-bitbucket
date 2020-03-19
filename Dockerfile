FROM debian:buster-slim

ARG PHPVERSION=7.3

RUN apt-get update && apt-get -y install patch git gnupg ca-certificates apt-transport-https wget && \
wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add - && \
echo "deb https://packages.sury.org/php/ stretch main" | tee /etc/apt/sources.list.d/php.list && \
apt-get -y install php$PHPVERSION php$PHPVERSION-fpm php$PHPVERSION-curl php$PHPVERSION-dom \
php$PHPVERSION-zip php$PHPVERSION-gd php$PHPVERSION-imagick php$PHPVERSION-xmlwriter php$PHPVERSION-mbstring \
php$PHPVERSION-pdo-mysql

COPY --from=composer /usr/bin/composer /usr/bin/composer

# apt-get remove ...
RUN mkdir /run/php/ && ln -s /usr/sbin/php-fpm$PHPVERSION /usr/sbin/php-fpm
COPY www.conf /etc/php/$PHPVERSION/fpm/pool.d/www.conf
EXPOSE 9000
CMD ["/usr/sbin/php-fpm", "-F", "-R"]
