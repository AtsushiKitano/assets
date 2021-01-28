#!/bin/sh

sh $1/testNetworkModule.sh

if [ $? != 0 ]; then
    exit 1
fi
