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
while [ ! -f "$DIR/npm_ready" ] && [ ! -f "$DIR/npm_error" ]; do
    sleep 1
done
if [ -f "$DIR/npm_ready" ]; then
    rm -f "$DIR/npm_ready"
    messages "Project Ready"
    exec npm run dev
elif [ -f "$DIR/npm_error" ]; then
    errors "Project Error" npm_error
    exec tail -f /dev/null
fi
