#!/bin/sh
KEY="/etc/ssl/app-ssl/$APP_SERVER_NAME/$APP_SERVER_NAME.key"
CRT="/etc/ssl/app-ssl/$APP_SERVER_NAME/$APP_SERVER_NAME.crt"
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
while [ ! -f "$KEY" ] || [ ! -f "$CRT" ]; do
    sleep 1
done
messages "Certificate Ready"
exec nginx -g "daemon off;"
