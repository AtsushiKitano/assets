#!/bin/sh

PJ=$1

tee attributes.yaml <<EOF > /dev/null
project:
  id: '$PJ'
EOF
