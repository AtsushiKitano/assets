#!/bin/sh

testExistTestNetwork()
{
    gcloud compute networks describe test > /dev/null 2>&1
    assertEquals $? 0
}

testCidrTestNetwork()
{
    assertEquals $(gcloud compute networks subnets describe --region=asia-northeast1 test | grep ipCidrRange | awk '{print $2}') "192.168.0.0/29"
}

. shunit2
