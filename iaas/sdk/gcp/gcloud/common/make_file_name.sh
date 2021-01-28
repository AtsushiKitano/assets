#!/bin/sh

make_file_name () {
    fullpath=$(echo $1 | tr '/' ' ')
    declare -a fullpatharray=($fullpath)
    echo ${fullpatharray[$((${#fullpatharray[@]} - 1))]}
}
