#!/bin/sh

make_header () {
    if [ ! -e $2/csv/$3.csv ]; then
        echo $1 > $2/csv/$3.csv
    fi
}
