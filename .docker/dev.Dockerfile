FROM alpine:latest

ARG APP_USER_NAME
ARG APP_USER_ID
ARG APP_GROUP_NAME
ARG APP_GROUP_ID

COPY ./.config/dev/start.sh /usr/local/bin/start.sh

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
    nodejs \
    npm \
    openssl \
    && if [ ! -f /usr/bin/php ]; then \
    ln -s /usr/bin/php82 /usr/bin/php; \
    fi \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === \
    'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') \
    { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --filename=composer --install-dir=/usr/local/bin \
    && php -r "unlink('composer-setup.php');" \
    && mkdir -p /etc/ssl/app-ssl \
    && chmod +x /usr/local/bin/start.sh

USER ${APP_USER_NAME}

WORKDIR /app

CMD ["/usr/local/bin/start.sh"]
