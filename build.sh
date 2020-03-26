#!/bin/bash
PHPVERSION="7.4"

perl -p -i -e "s|PHPVERSION=.*$|PHPVERSION=$PHPVERSION|g" Dockerfile
docker build -t insignagency/php:php$PHPVERSION .

if [ "$(git tag --list |grep php$PHPVERSION)" == "" ];
then
    git tag php$PHPVERSION
    echo "Pour pusher sur le remote :"
    echo "git push origin php$PHPVERSION"
else
    git tag -d php$PHPVERSION
    git tag php$PHPVERSION
    echo "Pour pusher sur le remote :"
    echo "git push --delete origin php$PHPVERSION"
    echo "git push origin php$PHPVERSION"
fi