FROM alpine:3.9

ARG PACKER_VERSION
ARG PACKER_VERSION_SHA256SUM

COPY packer_${PACKER_VERSION}_linux_amd64.zip .
RUN echo "${PACKER_VERSION_SHA256SUM}  packer_${PACKER_VERSION}_linux_amd64.zip" > checksum && sha256sum -c checksum

RUN /usr/bin/unzip packer_${PACKER_VERSION}_linux_amd64.zip

ARG CINC_VERSION
ARG CINC_MINOR_VERSION
ARG CINC_VERSION_SHA256SUM

COPY cinc-auditor_${CINC_VERSION}-${CINC_MINOR_VERSION}_amd64.deb .
RUN echo -n "${CINC_VERSION_SHA256SUM}  cinc-auditor_${CINC_VERSION}-${CINC_MINOR_VERSION}_amd64.deb" > checksum && sha256sum -c checksum


FROM ubuntu
ARG ANSIBLE_VERSION
ARG CINC_VERSION
ARG CINC_MINOR_VERSION

COPY cinc-auditor_${CINC_VERSION}-${CINC_MINOR_VERSION}_amd64.deb /tmp


RUN dpkg -i /tmp/cinc-auditor_${CINC_VERSION}-${CINC_MINOR_VERSION}_amd64.deb && \
  rm -f /tmp/cinc-auditor_${CINC_VERSION}-${CINC_MINOR_VERSION}_amd64.deb && \
  apt-get -y update && \
  apt-get -y install tzdata

ENV TZ=Asia/Tokyo

RUN apt-get -y install \
  ca-certificates \
  ruby \
  ruby-dev \
  gcc \
  g++ \
  make \
  openssh-server \
  python3-pip  &&\
  pip3 install paramiko ansible==${ANSIBLE_VERSION} &&\
  gem install inspec-bin inspec &&\
  rm -rf /var/lib/apt/lists/*
COPY --from=0 packer /usr/bin/packer
ENTRYPOINT ["/usr/bin/packer"]
