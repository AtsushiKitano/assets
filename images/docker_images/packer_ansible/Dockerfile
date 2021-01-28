FROM alpine:3.9

ARG PACKER_VERSION
ARG PACKER_VERSION_SHA256SUM

COPY packer_${PACKER_VERSION}_linux_amd64.zip .
RUN echo "${PACKER_VERSION_SHA256SUM}  packer_${PACKER_VERSION}_linux_amd64.zip" > checksum && sha256sum -c checksum

RUN /usr/bin/unzip packer_${PACKER_VERSION}_linux_amd64.zip

FROM ubuntu
ARG ANSIBLE_VERSION
RUN apt-get -y update && \
  apt-get -y install \
  ca-certificates \
  ruby \
  ruby-dev \
  gcc \
  g++ \
  make \
  python3-pip  &&\
  pip3 install paramiko ansible==${ANSIBLE_VERSION} &&\
  gem install inspec-bin inspec &&\
  rm -rf /var/lib/apt/lists/*
COPY --from=0 packer /usr/bin/packer
ENTRYPOINT ["/usr/bin/packer"]
