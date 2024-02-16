FROM alpine:latest

ARG APP_USER_NAME
ARG APP_USER_ID
ARG APP_GROUP_NAME
ARG APP_GROUP_ID

COPY ./.config/php/start.sh /usr/local/bin/start.sh

RUN addgroup -g "${APP_GROUP_ID}" "${APP_GROUP_NAME}" && \
    adduser -u "${APP_USER_ID}" -D -G "${APP_GROUP_NAME}" "${APP_USER_NAME}" && \
    apk add --no-cache \
    php83 \
    php83-ctype \
    php83-curl \
    php83-dom \
    php83-fileinfo \
    php83-fpm \
    php83-mbstring \
    php83-opcache \
    php83-openssl \
    php83-pdo \
    php83-pdo_mysql \
    php83-pdo_sqlite \
    php83-phar \
    php83-session \
    php83-simplexml \
    php83-tokenizer \
    php83-xml \
    php83-xmlreader \
    php83-xmlwriter && \
    sed -i "/^user/ s|nobody|${APP_USER_NAME}|" /etc/php83/php-fpm.d/www.conf && \
    sed -i "/^group/ s|nobody|${APP_GROUP_NAME}|" /etc/php83/php-fpm.d/www.conf && \
    sed -i "/^listen/ s|127.0.0.1:||" /etc/php83/php-fpm.d/www.conf && \
    chmod +x /usr/local/bin/start.sh

CMD ["/usr/local/bin/start.sh"]
