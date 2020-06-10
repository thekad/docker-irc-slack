FROM golang:1.13-alpine AS builder

ENV GO111MODULE=on

RUN apk update && \
    apk add --no-cache git && \
    go get -d -v github.com/insomniacslk/irc-slack/... && \
    cd $GOPATH/src/github.com/insomniacslk/irc-slack/ && \
    CGO_ENABLED=0 go build -ldflags="-w -s" -o /go/bin/irc-slack

# use alpine:latest to use dumb-init

FROM docker.io/library/alpine:latest

ENV LISTEN_PORT=6667
ENV LISTEN_ADDR=127.0.0.1
ENV IRC_HOSTNAME=irc-slack

RUN apk update && \
    apk upgrade && \
    apk add --no-cache ca-certificates dumb-init

COPY --from=builder /go/bin/irc-slack /usr/bin/irc-slack
EXPOSE 6667

ENTRYPOINT ["/usr/bin/dumb-init"]
CMD /usr/bin/irc-slack -H ${LISTEN_ADDR} -p ${LISTEN_PORT} -s ${IRC_HOSTNAME}
