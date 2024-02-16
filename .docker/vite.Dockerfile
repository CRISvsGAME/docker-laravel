FROM alpine:latest

ARG APP_USER_NAME
ARG APP_USER_ID
ARG APP_GROUP_NAME
ARG APP_GROUP_ID

COPY ./.config/vite/start.sh /usr/local/bin/start.sh

RUN addgroup -g "${APP_GROUP_ID}" "${APP_GROUP_NAME}" \
    && adduser -u "${APP_USER_ID}" -D -G "${APP_GROUP_NAME}" "${APP_USER_NAME}" \
    && apk add --no-cache \
    nodejs \
    npm \
    && chmod +x /usr/local/bin/start.sh

USER ${APP_USER_NAME}

WORKDIR /app

CMD ["/usr/local/bin/start.sh"]
