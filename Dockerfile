FROM alpine:edge AS build_packer
RUN apk update
RUN apk upgrade
RUN apk add --update go gcc g++ git make musl-dev
WORKDIR /app
ENV GOPATH="/app" \
    CGO_ENABLED="1" \
    GOOS="linux"
RUN mkdir -p $(go env GOPATH)/src/github.com/hashicorp && \
    cd $_ && \
    git clone https://github.com/hashicorp/packer.git && \
    cd packer && \
    make dev
#ADD src /app/src
#RUN CGO_ENABLED=1 GOOS=linux go install -a server

# FROM alpine:latest
FROM alpine:edge AS packer_qemu
COPY --from=build_packer \
     /app/src/github.com/hashicorp/packer/packer \
     /bin/packer
#
# https://wiki.alpinelinux.org/wiki/Edge
#
#RUN sed -i -e 's/v[[:digit:]]\.[[:digit:]]/edge/g' /etc/apk/repositories && \

#RUN ln -s /lib /lib64 && \
#    apk update && \
#    apk upgrade --available && \
#    apk add qemu-img && \
#    apk add qemu-system-x86_64 && \
#    apk add go git make gcc musl-dev && \
#    mkdir -p $(go env GOPATH)/src/github.com/hashicorp && \
#    cd $_ && \
#    git clone https://github.com/hashicorp/packer.git && \
#    cd packer && \
#    make dev && \
#    apk del go git make gcc musl-dev

#ENTRYPOINT [ "packer" ]
#CMD '--help'
