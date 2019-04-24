FROM alpine:latest

#
# https://wiki.alpinelinux.org/wiki/Edge
#
RUN sed -i -e 's/v[[:digit:]]\.[[:digit:]]/edge/g' /etc/apk/repositories && \
    apk update && \
    apk upgrade --available && \
    apk add qemu-img && \
    apk add qemu-system-x86_64 && \
    apk add go git make gcc musl-dev && \
    mkdir -p $(go env GOPATH)/src/github.com/hashicorp && \
    cd $_ && \
    git clone https://github.com/hashicorp/packer.git && \
    cd packer && \
    make dev && \
    apk del go git make gcc musl-dev

ENTRYPOINT [ "packer" ]
CMD '--help'
