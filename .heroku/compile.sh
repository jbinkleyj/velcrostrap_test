#!/usr/bin/env bash

# fail fast
set -e

# figure out where we are top level of the code lies
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_DIR="$( dirname "${THIS_DIR}" )"
APP_DIR="$( dirname "${REPO_DIR}" )"

cd $REPO_DIR
unset GIT_DIR
curl -s http://getcomposer.org/installer | $APP_DIR/bin/php
$APP_DIR/bin/php composer.phar install --prefer-dist

# laravel publish
$APP_DIR/bin/php artisan config:publish rcrowe/twigbridge
$APP_DIR/bin/php artisan config:publish jbinkleyj/velcrostrap
$APP_DIR/bin/php artisan asset:publish jbinkleyj/velcrostrap

# set write perms on storage
find app/storage/ -type d -exec chmod 0777 {} \;

# cleanup .git directory
find $REPO_DIR -maxdepth 1 -name .git -exec rm -rf {} \;
