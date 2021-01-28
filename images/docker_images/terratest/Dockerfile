FROM alpine:3.9

ARG TERRAFORM_VERSION
COPY terraform_${TERRAFORM_VERSION}_linux_amd64.zip .
RUN /usr/bin/unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip

FROM golang
RUN go get github.com/gruntwork-io/terratest/modules/terraform \
  && go get github.com/stretchr/testify/assert
COPY --from=0 terraform /bin/terraform
