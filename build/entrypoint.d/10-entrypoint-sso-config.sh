#!/bin/bash
# Copyright (C) 2026 Alexander Wolz <mail@alexanderwolz.de>

function run() {
    if [ "$(id -u)" = 0 ]; then
        su -p www-data -s /bin/sh -c "$1"
    else
        sh -c "$1"
    fi
}

echo "Creating OIDC provider 'Keycloak'"
KEYCLOAK_CONFIG="{\
    \"name\": \"keycloak\",\
    \"title\": \"Keycloak\",\
    \"authorizeUrl\": \"$KEYCLOAK_AUTH_URL\",\
    \"tokenUrl\": \"$KEYCLOAK_TOKEN_URL\",\
    \"userInfoUrl\": \"$KEYCLOAK_USER_URL\",\
    \"logoutUrl\": \"$KEYCLOAK_LOGOUT_URL\",\
    \"clientId\": \"$KEYCLOAK_CLIENT_ID\",\
    \"clientSecret\": \"$KEYCLOAK_CLIENT_SECRET\",\
    \"scope\": \"openid\",\
    \"displayNameClaim\": \"name\",\
    \"groupsClaim\": \"resource_access.nextcloud.roles\",\
    \"style\": \"keycloak\",\
    \"defaultGroup\": \"\",\
    \"groupMapping\":{\"admin\":\"admin\"}\
    }"

JSON="{\"custom_oidc\": [\
    $KEYCLOAK_CONFIG\
    ]}"

run "php occ config:app:set sociallogin custom_providers --value='$JSON'"
run "php occ config:app:set sociallogin update_profile_on_login --value='1'"
run "php occ config:app:set sociallogin hide_default_login --value='1'"


# https://cloud.alexanderwolz.de/login?noredir=1

