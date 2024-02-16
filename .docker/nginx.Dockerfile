FROM alpine:latest

ARG APP_SERVER_NAME
ARG PMA_SERVER_NAME

COPY ./.config/nginx/start.sh /usr/local/bin/start.sh

COPY ./.config/nginx/default.conf /etc/nginx/http.d/default.conf

RUN apk add --no-cache \
    nginx && \
    sed -i "s|APP_SERVER_NAME|${APP_SERVER_NAME}|g" /etc/nginx/http.d/default.conf && \
    sed -i "s|PMA_SERVER_NAME|${PMA_SERVER_NAME}|g" /etc/nginx/http.d/default.conf && \
    mkdir -p /etc/ssl/app-ssl && \
    chmod +x /usr/local/bin/start.sh

EXPOSE ${HTTP_PORT} ${HTTPS_PORT} ${VITE_PORT}

CMD ["/usr/local/bin/start.sh"]
