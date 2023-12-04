FROM alpine:latest

ARG APP_USER_NAME
ARG APP_USER_ID
ARG APP_GROUP_NAME
ARG APP_GROUP_ID

COPY ./.config/php/start.sh /usr/local/bin/start.sh

RUN addgroup -g ${APP_GROUP_ID} ${APP_GROUP_NAME} \
    && adduser -u ${APP_USER_ID} -D -G ${APP_GROUP_NAME} ${APP_USER_NAME} \
    && apk add --no-cache \
    php82 \
    php82-ctype \
    php82-curl \
    php82-dom \
    php82-fileinfo \
    php82-mbstring \
    php82-openssl \
    php82-pdo \
    php82-session \
    php82-tokenizer \
    php82-xml \
    php82-fpm \
    php82-mysqlnd \
    php82-opcache \
    php82-pdo_mysql \
    php82-phar \
    php82-sockets \
    php82-xmlwriter \
    php82-pecl-memcached \
    && sed -i "/^user/ s|nobody|${APP_USER_NAME}|" /etc/php82/php-fpm.d/www.conf \
    && sed -i "/^group/ s|nobody|${APP_GROUP_NAME}|" /etc/php82/php-fpm.d/www.conf \
    && sed -i "/^listen/ s|127.0.0.1:||" /etc/php82/php-fpm.d/www.conf \
    && chmod +x /usr/local/bin/start.sh

CMD ["/usr/local/bin/start.sh"]
