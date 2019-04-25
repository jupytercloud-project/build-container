#FROM alpine:edge AS build_packer
FROM alpine:latest AS build_packer
RUN apk update
RUN apk upgrade
RUN apk add --update go gcc git make musl-dev
#RUN git clone https://github.com/hashicorp/packer.git && \
#    cd packer && \
#    make dev
#RUN pwd && \
#    ls -alFhR packer/
RUN mkdir -p /packer/bin && \
    cd /packer/bin && \
    wget https://releases.hashicorp.com/packer/1.4.0/packer_1.4.0_linux_amd64.zip | unzip

# FROM alpine:edge
FROM alpine:latest
COPY --from=build_packer \
     /packer/bin/packer \
     /bin/packer
#
# https://wiki.alpinelinux.org/wiki/Edge
#
#RUN sed -i -e 's/v[[:digit:]]\.[[:digit:]]/edge/g' /etc/apk/repositories && \
RUN apk update && \
    apk upgrade --available && \
    apk add qemu-img && \
    apk add qemu-system-x86_64

#ENTRYPOINT [ "packer" ]
#CMD '--help'
