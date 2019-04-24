FROM alpine:latest
RUN apk update & \
    apk add qemu-img \
    apk add qemu-system-x86_64 \
    apk add go git make \
    mkdir -p $(go env GOPATH)/src/github.com/hashicorp && cd $_ \
    git clone https://github.com/hashicorp/packer.git \
    cd packer \
    make dev \
    apk del go git make
    
