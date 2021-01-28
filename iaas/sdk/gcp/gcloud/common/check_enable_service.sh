#!/bin/sh

check_enable_service () {
    grep $1 $2/json/service_list/$3.txt

    if [ $? != 0 ]; then
        exit 0
    fi
}
