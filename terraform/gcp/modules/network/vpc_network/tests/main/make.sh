#!/bin/sh

PJ=$1
PREFIX=$2
TERRAFORMVERSION=$3

tee terraform.tf <<EOF > /dev/null
terraform {
    backend "gcs" {
        bucket = "$PJ-terraform-modules-state"
        prefix = "$PREFIX"
    }
}

provider "google" {
    project = terraform.workspace
}

provider "google-beta" {
    project = terraform.workspace
}
EOF
