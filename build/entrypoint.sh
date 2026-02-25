#!/bin/bash
# Copyright (C) 2026 Alexander Wolz <mail@alexanderwolz.de>

function run() {
  if [ "$(id -u)" = 0 ]; then
    su -p www-data -s /bin/sh -c "$1"
  else
    sh -c "$1"
  fi
}

echo "executing /entrypoint-nextcloud-install.sh .."
sh /entrypoint-nextcloud-install.sh "$@"
echo "done executing /entrypoint-nextcloud-install.sh .."

# waiting for Nextcloud being fully initialised
echo "Waiting for Nextcloud to be ready..."
until run "php /var/www/html/occ status" | grep -q "installed: true"; do
  echo "Nextcloud not ready yet, waiting..."
  sleep 5
done

echo "Nextcloud is ready, installing apps..."

for APP in $(echo $DEFAULT_APPS | sed "s/,/ /g")
do
  echo "installing $APP .."
  # Check if app already installed
  if ! run "php /var/www/html/occ app:list | grep -q \"$APP\""; then
    run "php /var/www/html/occ app:install $APP" || echo "Failed to install $APP"
  else
    echo "$APP already installed"
  fi
done

# execute additional scripts
SCRIPT_DIR="/entrypoint.d"
if [ -d "$SCRIPT_DIR" ]; then
  for SCRIPT in $SCRIPT_DIR/*.sh; do
    echo "executing $SCRIPT.."
    bash $SCRIPT
  done
fi

echo "Running service $@"
exec "$@"