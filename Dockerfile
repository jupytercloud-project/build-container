#FROM alpine:edge AS build_packer
FROM alpine:latest AS build_packer
RUN apk update
RUN apk upgrade
RUN apk add --update go gcc git make musl-dev which
#RUN git clone https://github.com/hashicorp/packer.git && \
#    cd packer && \
#    make dev
#RUN pwd && \
#    ls -alFhR packer/
RUN mkdir -p /packer/bin && \
    cd /packer/bin && \
    wget https://releases.hashicorp.com/packer/1.4.0/packer_1.4.0_linux_amd64.zip && \
    unzip packer_1.4.0_linux_amd64.zip
RUN go get -u -v github.com/tcnksm/ghr
RUN ls -alFh /root/bin
RUN go get -u -v github.com/rackspace/gophercloud

# FROM alpine:edge
FROM alpine:latest
COPY --from=build_packer \
     /packer/bin/packer \
     /bin/packer
COPY --from=build_packer \
     /bin/ghr \
     /bin/ghr
#
# https://wiki.alpinelinux.org/wiki/Edge
#
#RUN sed -i -e 's/v[[:digit:]]\.[[:digit:]]/edge/g' /etc/apk/repositories && \
RUN apk update && \
    apk upgrade --available && \
    apk add bash && \
    apk add curl && \
    apk add qemu-img && \
    apk add qemu-system-x86_64 && \
    apk add jq && \
    apk add gcc libffi-dev musl-dev openssl-dev python-dev && \
    apk add py-pip && \
    pip install python-openstackclient && \
    wget https://github.com/mikefarah/yq/releases/download/2.3.0/yq_linux_amd64 && \
    mv yq_linux_amd64 /bin/yq && \
    chmod a+x /bin/yq && \
    echo $'#!/bin/sh\n\
    echo \'{ "osfamily": "Docker" }\'\n'\
    > /bin/facter-fake && \
    chmod a+x /bin/facter-fake && \
    ln -s /bin/facter-fake /bin/facter && \
    apk del gcc libffi-dev musl-dev openssl-dev python-dev && \
    rm -rf /var/cache/apk/*

EXPOSE 6000-6020
#ENTRYPOINT [ "packer" ]
#CMD '--help'
