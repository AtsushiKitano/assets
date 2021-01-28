#!/bin/sh

FILEPATH=$1

tee $FILEPATH/terraform.tf <<EOF
provider "aws" {
  region     = local.env[terraform.workspace]
  access_key = local.credential[0].AccessKeyID
  secret_key = local.credential[0].SecretAccessKey
}

variable "aws_credential" {}

locals {
  credential = csvdecode(file(var.aws_credential))
  env = {
    dev  = "us-west-2"
    stg  = "us-east-2"
    prd  = "ap-northeast-1"
  }
}
EOF
