#!/bin/sh
DIR="/app"
errors() {
    messages "$1"
    if [ "$2" ]; then
        rm -f "$DIR/$2"
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
messages "Waiting for Project"
while [ ! -f "$DIR/php_ready" ] && [ ! -f "$DIR/php_error" ]; do
    sleep 1
done
if [ -f "$DIR/php_ready" ]; then
    su -s /bin/sh "$APP_USER_NAME" -c "php83 $DIR/artisan config:cache"
    su -s /bin/sh "$APP_USER_NAME" -c "php83 $DIR/artisan event:cache"
    su -s /bin/sh "$APP_USER_NAME" -c "php83 $DIR/artisan route:cache"
    su -s /bin/sh "$APP_USER_NAME" -c "php83 $DIR/artisan view:cache"
    rm -f "$DIR/php_ready"
    messages "Project Ready"
    exec php-fpm83 -F
elif [ -f "$DIR/php_error" ]; then
    errors "Project Error" php_error
    exec tail -f /dev/null
fi
