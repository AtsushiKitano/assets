#!/bin/sh

sudo /usr/sbin/td-agent-gem install fluent-plugin-bigquery
sudo systemctl restart td-agent
