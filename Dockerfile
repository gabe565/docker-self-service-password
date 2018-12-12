# Final Image
FROM php:7.2-fpm-alpine

ARG VERSION=1.3
ENV VERSION=$VERSION

RUN set -x \
    && apk add \
        curl \
        fcgi \
        libldap \
        tar \
    && apk add --virtual .build-deps \
        $PHPIZE_DEPS \
        curl-dev \
        openldap-dev \
    && docker-php-ext-install curl ldap \
    && apk del .build-deps \
    && cd /usr/local/etc \
    && sed -ri \
        -e 's/^;(ping\.path)/\1/' /usr/local/etc/php-fpm.d/www.conf \
        php-fpm.d/www.conf \
    && cd "$PHP_INI_DIR" \
    && ln -s php.ini-production php.ini \
    && sed -ri \
        -e 's/^(expose_php).*$/\1 = Off/' \
        php.ini-production \
    && curl -sLo /usr/src/app.tar.gz "https://github.com/ltb-project/self-service-password/archive/v${VERSION}.tar.gz" \
    && rm -rf /tmp/* /var/cache/apk/*

WORKDIR /var/www/html
VOLUME /var/www/html

COPY --chown=root root/ /

HEALTHCHECK --interval=1m --timeout=5s \
    CMD /health-check

CMD ["/entrypoint"]
