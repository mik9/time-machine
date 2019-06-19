FROM alpine:edge

RUN apk --no-cache add samba
ADD start-samba.sh /
ENTRYPOINT /start-samba.sh
