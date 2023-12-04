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
    messages "Project Ready"
    rm -f "$DIR/php_ready"
    # php82 "$DIR/artisan" config:cache
    # php82 "$DIR/artisan" event:cache
    # php82 "$DIR/artisan" route:cache
    # php82 "$DIR/artisan" view:cache
    exec php-fpm82 -F
elif [ -f "$DIR/php_error" ]; then
    errors "Project Error" php_error
    exec tail -f /dev/null
fi
