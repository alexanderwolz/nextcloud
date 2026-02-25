#!/bin/bash
# Copyright (C) 2026 Alexander Wolz <mail@alexanderwolz.de>

function run() {
    if [ "$(id -u)" = 0 ]; then
        su -p www-data -s /bin/sh -c "$1"
    else
        sh -c "$1"
    fi
}

function disableUser(){
    echo "Disabling user $1"
    run "php occ user:disable $1"
}

#we disable default admin account becaue we use OIDC
if [ ! -e "$NEXTCLOUD_ADMIN_USER" ]; then
    disableUser $NEXTCLOUD_ADMIN_USER
fi