#!/bin/bash
PHPVERSION="7.4"

perl -p -i -e "s|PHPVERSION=.*$|PHPVERSION=$PHPVERSION|g" Dockerfile
docker build -t insignagency/php:php$PHPVERSION .

if [[ "$(git branch |grep php$PHPVERSION)" =~ (^| )php$PHPVERSION( |$) ]];
then
    git checkout php$PHPVERSION
else
    git checkout -b php$PHPVERSION
fi

git diff

echo "To push:"
echo "git push -u origin php$PHPVERSION"