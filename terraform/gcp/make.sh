#!/bin/sh

FILEPATH=$1

tee $FILEPATH/terraform.tf <<EOF
terraform {
  required_version = "~> 0.13.0"
}

provider "google" {
  project = terraform.workspace
}

provider "google-beta" {
  project = terraform.workspace
}
EOF
