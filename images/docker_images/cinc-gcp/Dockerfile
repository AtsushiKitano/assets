FROM cincproject/auditor

RUN apt-get install -y curl && \
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
  tee -a /etc/apt/sources.list.d/google-cloud-sdk.list &&\
  apt-get install -y apt-transport-https ca-certificates gnupg &&\
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
  apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - &&\
  apt-get update && apt-get install -y google-cloud-sdk
