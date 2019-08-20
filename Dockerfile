FROM alpine:latest

ENV LISTEN_PORT=6666
ENV LISTEN_ADDR=127.0.0.1
ENV IRC_HOSTNAME=irc-slack

RUN apk update && \
    apk add --no-cache ca-certificates dumb-init

COPY irc-slack /usr/bin/irc-slack
EXPOSE 6666

ENTRYPOINT ["/usr/bin/dumb-init"]
CMD /usr/bin/irc-slack -H ${LISTEN_ADDR} -p ${LISTEN_PORT} -s ${IRC_HOSTNAME}
