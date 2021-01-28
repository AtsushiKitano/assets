#!/bin/sh

make_raw_log_dir () {
    if [ ! -d $1/json/$2 ]; then
        mkdir $1/json/$2
    fi
}

make_log_parent () {
    if [ ! -d $1/$2 ]; then
        mkdir -p $1/$2
    fi
}
