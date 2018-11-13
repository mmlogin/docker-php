FROM mtilson/ubuntu:bionic

ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF

ENV PHP_VERSION 7.1

RUN \
    sed -i "s/main\$/main universe/g" /etc/apt/sources.list && \
    /usr/local/sbin/docker-upgrade && \
    apt-get --assume-yes install \
        msmtp-mta \
        php-db \
    	php${PHP_VERSION}-fpm && \
    /usr/local/sbin/docker-cleanup

RUN mkdir -p /docker-entrypoint-init.d

COPY configure-php.sh /usr/local/sbin/configure-php
RUN /usr/local/sbin/configure-php

RUN echo "Source: https://github.com/mtilson/docker-php\nBuild date: $(date --iso-8601=ns)" >/README

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["sh", "-c", "php-fpm${PHP_VERSION}"]
