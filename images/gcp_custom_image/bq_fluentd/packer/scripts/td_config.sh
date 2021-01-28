#!/bin/sh

PJ=$(gcloud config get-value project)
sed -i -e "s/MY_PROJECT_NAME/$PJ/g" /etc/td-agent/td-agent.conf
sudo systemctl restart td-agent
