#!/bin/sh
DIR="/app"
KEY="/etc/ssl/app-ssl/$APP_URL/$APP_URL.key"
CRT="/etc/ssl/app-ssl/$APP_URL/$APP_URL.crt"
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
messages "Waiting for Certificate"
if [ ! -f "$KEY" ] && [ ! -f "$CRT" ]; then
    messages "Creating Certificate"
    mkdir -p /etc/ssl/app-ssl/$APP_URL
    openssl req -new -nodes -x509 -days 365 -newkey rsa:2048 \
    -addext "basicConstraints = critical, CA:FALSE" \
    -addext "extendedKeyUsage = serverAuth" \
    -addext "keyUsage = critical, digitalSignature, keyEncipherment" \
    -addext "subjectAltName = DNS:$APP_URL, DNS:*.$APP_URL" \
    -subj "/C=$CRT_C/ST=$CRT_ST/L=$CRT_L/O=$CRT_O/OU=$CRT_OU/CN=$CRT_CN/emailAddress=$CRT_EM" \
    -keyout /etc/ssl/app-ssl/$APP_URL/$APP_URL.key \
    -out /etc/ssl/app-ssl/$APP_URL/$APP_URL.crt
fi
messages "Certificate Ready"
messages "Waiting for Project"
if [ -d "$DIR" ]; then
    if [ -f "$DIR/.gitkeep" ]; then
        rm -f "$DIR/.gitkeep"
    fi
    if [ "$(ls -A $DIR)" ]; then
        if composer install; then
            messages "Composer Install Succeeded"
        else
            errors "Composer Install Failed" php_error
        fi
        if npm install; then
            messages "Npm Install Succeeded"
        else
            errors "Npm Install Failed" npm_error
        fi
    else
        if composer create-project laravel/laravel .; then
            messages "Composer Create Succeeded"
        else
            errors "Composer Create Failed" php_error
        fi
        if npm install; then
            messages "Npm Install Succeeded"
        else
            errors "Npm Install Failed" npm_error
        fi
    fi
    if [ ! -f "$DIR/.env" ] && [ -f "$DIR/.env.example" ]; then
        cp "$DIR/.env.example" "$DIR/.env"
    fi
    if [ -f "$DIR/.env" ]; then
        sed -i "/^APP_URL/ s|=.*|=https://$APP_URL|g" "$DIR/.env"
        sed -i "/^DB_HOST/ s|=.*|=$DB_HOST|g" "$DIR/.env"
        sed -i "/^DB_DATABASE/ s|=.*|=$DB_DATABASE|g" "$DIR/.env"
        sed -i "/^DB_USERNAME/ s|=.*|=$DB_USERNAME|g" "$DIR/.env"
        sed -i "/^DB_PASSWORD/ s|=.*|=$DB_PASSWORD|g" "$DIR/.env"
        sed -i "/^CACHE_DRIVER/ s|=.*|=memcached|g" "$DIR/.env"
        sed -i "/^SESSION_DRIVER/ s|=.*|=memcached|g" "$DIR/.env"
        sed -i "/^MEMCACHED_HOST/ s|=.*|=memcached|g" "$DIR/.env"
    fi
    if [ -f "$DIR/vite.config.js" ]; then
        VITE="\    server: {\n\        host: 'vite',\n\        hmr: {\n\            host: '$APP_URL',\n\            protocol: 'wss',\n\        },\n\    },"
        if ! grep -qF "server: {" "$DIR/vite.config.js"; then
            sed -i "/export default/ a $VITE" "$DIR/vite.config.js"
        fi
    fi
    messages "Project Ready"
    touch "$DIR/php_ready"
    touch "$DIR/npm_ready"
else
    errors "Directory $DIR Missing"
fi
exec tail -f /dev/null
