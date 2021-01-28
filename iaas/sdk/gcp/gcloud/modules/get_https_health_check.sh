#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=https_health_check
CSVHEADER="name,project,port,requestPath,timeoutSec,unhealthyTreshold,healthyThreshold,checkIntervalSec"
MODULEPATH="./common/"

SERVICES=(
    compute.googleapis.com
)

out_modules=(
    make_output_dir.sh \
        check_enable_service.sh \
        make_output_header.sh
)

for module in ${out_modules[@]}; do
    source $MODULEPATH$module
done

for sv in ${SERVICES[@]}; do
    check_enable_service $sv $OUTPUTDIR $PROJECT
done

make_raw_log_dir $OUTPUTDIR $OUTPUT
make_header $CSVHEADER $OUTPUTDIR $OUTPUT

https_health_checks=$(gcloud compute https-health-checks list --project $PROJECT | awk 'NR>1{print $1}')

for hhc in ${http_health_checks[@]}; do
    gcloud compute https-health-checks describe --project $PROJECT --format json $hhc |\
        tee $OUTPUTDIR/json/$OUTPUT/$hhc-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'",.port,.requestPath,.timeoutSec,.unhealthyTreshold,.healthyThreshold,.checkIntervalSec]|@csv' >> $OUTPUTDIR/csv/$OUTPUT.csv
done
