FROM mtilson/ubuntu:bionic

ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF

ENV PHP_VER 7.1
ENV DEL_LIB_PHP_DIR \
    /usr/lib/php/20131226 \
    /usr/lib/php/20151012 \
    /usr/lib/php/20170718 \
    /usr/lib/php/${PHP_VER}
ENV DEL_PHP_DIR \
    /etc/php/5.6 \
    /etc/php/7.0 \
    /etc/php/7.2 \
    /etc/php/7.3

COPY files/ppa-ondrej.pgp /root/ppa-ondrej.pgp

RUN \
    sed -i "s/main\$/main universe/g" /etc/apt/sources.list && \
    /usr/local/sbin/docker-upgrade && \
    apt-get --assume-yes install --no-install-recommends --no-install-suggests \
        msmtp-mta \
        gnupg && \
    /usr/local/sbin/docker-cleanup && \
    cat /root/ppa-ondrej.pgp | apt-key add && \
    printf "deb [arch=amd64] http://ppa.launchpad.net/ondrej/php/ubuntu bionic main\n" \
        > /etc/apt/sources.list.d/ondrej.list && \
    rm -f /root/ppa-ondrej.pgp && \
    /usr/local/sbin/docker-upgrade && \
    apt-get --assume-yes install --no-install-recommends --no-install-suggests \
        php${PHP_VER}-amqp \
        php${PHP_VER}-apcu \
        php${PHP_VER}-bcmath \
        php${PHP_VER}-db \
        php${PHP_VER}-cli \
        php${PHP_VER}-curl \
        php${PHP_VER}-fpm \
        php${PHP_VER}-geoip \
        php${PHP_VER}-gnupg \
        php${PHP_VER}-igbinary \
        php${PHP_VER}-imagick \
        php${PHP_VER}-intl \
        php${PHP_VER}-json \
        php${PHP_VER}-lua \
        php${PHP_VER}-mailparse \
        php${PHP_VER}-mbstring \
        php${PHP_VER}-memcached \
        php${PHP_VER}-mongodb \
        php${PHP_VER}-mysql \
        php${PHP_VER}-oauth \
        php${PHP_VER}-opcache \
        php${PHP_VER}-radius \
        php${PHP_VER}-raphf \
        php${PHP_VER}-redis \
        php${PHP_VER}-sodium \
        php${PHP_VER}-solr \
        php${PHP_VER}-sqlite3 \
        php${PHP_VER}-ssh2 \
        php${PHP_VER}-stomp \
        php${PHP_VER}-uploadprogress \
        php${PHP_VER}-uuid \
        php${PHP_VER}-xml \
        php${PHP_VER}-zip \
        php${PHP_VER}-zmq && \
    /usr/local/sbin/docker-cleanup && \
    rm -rf ${DEL_LIB_PHP_DIR} \
           ${DEL_PHP_DIR}

RUN mkdir -p /docker-entrypoint-init.d

COPY files/configure-php.sh /usr/local/sbin/configure-php
RUN /usr/local/sbin/configure-php

RUN echo "Source: https://github.com/mtilson/docker-php\nBuild date: $(date --iso-8601=ns)" >/README

COPY files/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["sh", "-c", "php-fpm${PHP_VER}"]
