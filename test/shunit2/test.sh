#!/bin/sh

testExistTestNetwork()
{
    gcloud compute networks describe test1 > /dev/null 2>&1
    assertEquals $? 0
}

# load shunit2
. shunit2
