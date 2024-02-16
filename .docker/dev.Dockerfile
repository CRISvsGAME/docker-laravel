FROM alpine:latest

ARG APP_USER_NAME
ARG APP_USER_ID
ARG APP_GROUP_NAME
ARG APP_GROUP_ID

COPY ./.config/dev/start.sh /usr/local/bin/start.sh

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
    php83-xmlwriter \
    nodejs \
    npm \
    openssl && \
    if [ ! -f /usr/bin/php ]; then \
    ln -s /usr/bin/php83 /usr/bin/php; \
    fi && \
    COMPOSER_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')" && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === '$COMPOSER_CHECKSUM') \
    { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php --filename=composer --install-dir=/usr/local/bin && \
    php -r "unlink('composer-setup.php');" && \
    mkdir -p /etc/ssl/app-ssl && \
    chmod +x /usr/local/bin/start.sh

USER ${APP_USER_NAME}

WORKDIR /app

CMD ["/usr/local/bin/start.sh"]
