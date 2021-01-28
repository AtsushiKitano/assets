#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=monitoring_alert
MODULEPATH="./common/"

SERVICES=(
    cloudmonitoring.googleapis.com
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

alertlists=$(gcloud alpha monitoring policies list --project $PROJECT | jq -r -c '.[] | .name')

for alert in ${alertlists[@]}; do
    tmp=$(echo $alert | tr '/' ' ')
    declare -a tmparray=($tmp)
    filename=${tmparray[$((${#tmparray[@]} - 1))]}

    gcloud alpha monitoring policies describe --project $PROJECT --format json $alert > $OUTPUTDIR/json/$OUTPUT/$filename-$PROJECT.json
done
