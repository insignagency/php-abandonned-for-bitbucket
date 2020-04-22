FROM debian:buster-slim

ARG PHPVERSION=7.4

RUN apt-get update && apt-get -y install patch git rsync default-mysql-client gnupg ca-certificates apt-transport-https wget && \
    wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add - && \
    echo "deb https://packages.sury.org/php/ buster main" | tee /etc/apt/sources.list.d/php.list && \
    apt-get update && apt-get -y install php$PHPVERSION php$PHPVERSION-fpm php$PHPVERSION-curl php$PHPVERSION-dom \
    php$PHPVERSION-zip php$PHPVERSION-gd php$PHPVERSION-imagick php$PHPVERSION-xmlwriter php$PHPVERSION-mbstring \
    php$PHPVERSION-pdo-mysql php$PHPVERSION-xdebug

RUN unlink /etc/php/$PHPVERSION/cli/conf.d/20-xdebug.ini && \
    unlink /etc/php/$PHPVERSION/fpm/conf.d/20-xdebug.ini && \
    sed -i "s|memory_limit = 128M|memory_limit = 1024M|" /etc/php/$PHPVERSION/fpm/php.ini

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN wget https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 && \
    chmod +x mhsendmail_linux_amd64 && \
    mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail

# apt-get remove ...
RUN mkdir /run/php/ && ln -s /usr/sbin/php-fpm$PHPVERSION /usr/sbin/php-fpm
COPY www.conf /etc/php/$PHPVERSION/fpm/pool.d/www.conf

RUN mkdir /var/www
WORKDIR /var/www
EXPOSE 9000
CMD ["/usr/sbin/php-fpm", "-F", "-R"]
