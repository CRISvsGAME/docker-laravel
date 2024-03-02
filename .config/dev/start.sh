#!/bin/sh
DIR="/app"
KEY="/etc/ssl/app-ssl/$DEV_APP_URL/$DEV_APP_URL.key"
CRT="/etc/ssl/app-ssl/$DEV_APP_URL/$DEV_APP_URL.crt"
errors() {
    messages "$1"
    if [ "$2" ]; then
        touch "$DIR/$2"
    fi
    exit 1
}
messages() {
    length=$((${#1} + 4))
    line=$(printf "#%.0s" $(seq 1 "$length"))
    echo ""
    echo "$line"
    echo "# $1 #"
    echo "$line"
    echo ""
}
composer_service() {
    if [ "$1" = "Install" ]; then
        composer install || errors "Composer Install Failed" php_error
    elif [ "$1" = "Create" ]; then
        composer create-project laravel/laravel . || errors "Composer Create Failed" php_error
    fi
    if [ -n "$COMPOSER_PKG" ]; then
        composer require "$COMPOSER_PKG" || errors "Composer Package Install Failed" php_error
    fi
    messages "Composer $1 Succeeded"
}
npm_service() {
    npm install || errors "Npm Install Failed" npm_error
    if [ -n "$NPM_PKG" ]; then
        npm install "$NPM_PKG" || errors "Npm Package Install Failed" npm_error
    fi
    messages "Npm Install Succeeded"
}
messages "Waiting for Certificate"
if [ ! -f "$KEY" ] && [ ! -f "$CRT" ]; then
    messages "Creating Certificate"
    mkdir -p "/etc/ssl/app-ssl/$DEV_APP_URL"
    openssl req -new -nodes -x509 -days 365 -newkey rsa:2048 \
        -addext "basicConstraints = critical, CA:FALSE" \
        -addext "extendedKeyUsage = serverAuth" \
        -addext "keyUsage = critical, digitalSignature, keyEncipherment" \
        -addext "subjectAltName = DNS:$DEV_APP_URL, DNS:*.$DEV_APP_URL" \
        -subj "/C=$CRT_C/ST=$CRT_ST/L=$CRT_L/O=$CRT_O/OU=$CRT_OU/CN=$CRT_CN/emailAddress=$CRT_EM" \
        -keyout "/etc/ssl/app-ssl/$DEV_APP_URL/$DEV_APP_URL.key" \
        -out "/etc/ssl/app-ssl/$DEV_APP_URL/$DEV_APP_URL.crt"
fi
messages "Certificate Ready"
messages "Waiting for Project"
if [ -d "$DIR" ]; then
    if [ -f "$DIR/.gitkeep" ]; then
        rm -f "$DIR/.gitkeep"
    fi
    if [ "$(ls -A $DIR)" ]; then
        composer_service "Install"
    else
        composer_service "Create"
    fi
    npm_service
    if [ ! -f "$DIR/.env" ] && [ -f "$DIR/.env.example" ]; then
        cp "$DIR/.env.example" "$DIR/.env"
    fi
    if [ -f "$DIR/.env" ]; then
        sed -i "/^APP_NAME/ s|=.*|=$DEV_APP_NAME|g" "$DIR/.env"
        sed -i "/^APP_URL/ s|=.*|=https://$DEV_APP_URL|g" "$DIR/.env"
        sed -i "/^DB_HOST/ s|=.*|=$DEV_DB_HOST|g" "$DIR/.env"
        sed -i "/^DB_DATABASE/ s|=.*|=$DEV_DB_DATABASE|g" "$DIR/.env"
        sed -i "/^DB_USERNAME/ s|=.*|=$DEV_DB_USERNAME|g" "$DIR/.env"
        sed -i "/^DB_PASSWORD/ s|=.*|=$DEV_DB_PASSWORD|g" "$DIR/.env"
        sed -i "/^CACHE_DRIVER/ s|=.*|=redis|g" "$DIR/.env"
        sed -i "/^QUEUE_CONNECTION/ s|=.*|=redis|g" "$DIR/.env"
        sed -i "/^SESSION_DRIVER/ s|=.*|=redis|g" "$DIR/.env"
        sed -i "/^REDIS_HOST/ s|=.*|=redis|g" "$DIR/.env"
        sed -i "/^REDIS_HOST/ a REDIS_CLIENT=predis" "$DIR/.env"
    fi
    if [ -f "$DIR/vite.config.js" ]; then
        VITE="\    server: {\n\
        host: 'vite',\n\
        hmr: {\n\
            protocol: 'wss',\n\
            host: '$DEV_APP_URL',\n\
            clientPort: '$DEV_VITE_PORT',\n\
        },\n\
    },"
        if ! grep -qF "server: {" "$DIR/vite.config.js"; then
            sed -i "/export default/ a $VITE" "$DIR/vite.config.js"
        fi
    fi
    touch "$DIR/php_ready"
    touch "$DIR/npm_ready"
    messages "Project Ready"
else
    errors "Directory $DIR Missing"
fi
exec tail -f /dev/null
