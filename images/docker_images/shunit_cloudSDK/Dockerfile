FROM alpine:3.9

ARG SHUNIT_VERSION
COPY shunit2-${SHUNIT_VERSION}.tgz .

RUN apk --update add tar \
  && /usr/bin/tar xzf shunit2-${SHUNIT_VERSION}.tgz

FROM google/cloud-sdk
ARG SHUNIT_VERSION
COPY --from=0 shunit2-${SHUNIT_VERSION}/src/shunit2 /bin/

