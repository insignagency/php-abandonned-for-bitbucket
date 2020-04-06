#!/bin/bash
PHPVERSION="7.4"

perl -p -i -e "s|PHPVERSION=.*$|PHPVERSION=$PHPVERSION|g" Dockerfile
docker build -t insignagency/php:php$PHPVERSION .

if [[ "$(git branch |grep php$PHPVERSION)" =~ (^| )php$PHPVERSION( |$) ]];
then
    git stash
    git checkout php$PHPVERSION
    git stash pop
else
    git stash
    git checkout -b php$PHPVERSION
    git stash pop
fi

git diff

echo "To push:"
echo "git push -u origin php$PHPVERSION"