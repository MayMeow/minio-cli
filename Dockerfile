FROM golang:1.16-alpine

LABEL maintainer="May Meow <emma@themaymeow.com>"

ENV GOPATH /go
ENV CGO_ENABLED 0
ENV GO111MODULE on

RUN  \
     apk add --no-cache git && \
     git clone https://github.com/minio/mc && cd mc && \
     go install -v -ldflags "$(go run buildscripts/gen-ldflags.go)"

FROM alpine:3.10

COPY --from=0 /go/bin/mc /usr/bin/mc

RUN  \
     apk add --no-cache ca-certificates && \
     echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf
