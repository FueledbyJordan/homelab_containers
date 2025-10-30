FROM alpine:latest

RUN apk add curl restic supercronic bash
ENTRYPOINT ["/usr/bin/supercronic", "-prometheus-listen-address", "0.0.0.0:9746", "/etc/cronfile"]
