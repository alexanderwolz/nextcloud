#!/bin/bash
# Copyright (C) 2026 Alexander Wolz <mail@alexanderwolz.de>

runuser -s /usr/local/bin/php - www-data /var/www/html/occ status 2>/dev/null | grep -e "installed: true" -e "maintenance: false" -e "needsDbUpgrade: false" | wc -l | [ "$(cat)" = "3" ]