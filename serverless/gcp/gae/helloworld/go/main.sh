#!/bin/sh

files=(\
       go.mod\
           main.go
)

GCS_PATH=$1

for file in ${files[@]}; do
    gsutil cp $file $GCS_PATH &
done
