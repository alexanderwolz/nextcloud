FROM nextcloud:32.0.6-apache

RUN mkdir /entrypoint.d \
    && sed -i 's/exec "$@"//g' /entrypoint.sh \
    && mv /entrypoint.sh /entrypoint-nextcloud-install.sh

COPY --chown=root:root entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --chown=root:root healthcheck.sh /opt/healthcheck.sh
RUN chmod +x /opt/healthcheck.sh

COPY --chown=root:root entrypoint.d/10-entrypoint-sso-config.sh /entrypoint.d/10-entrypoint-sso-config.sh
COPY --chown=root:root entrypoint.d/20-disable-users.sh /entrypoint.d/20-disable-users.sh
RUN chmod +x /entrypoint.d/10-entrypoint-sso-config.sh /entrypoint.d/20-disable-users.sh
