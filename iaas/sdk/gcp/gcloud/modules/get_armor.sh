#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=armor
MODULEPATH="./common/"
SERVICES=(
    compute.googleapis.com
)

out_modules=(
    make_output_dir.sh \
        check_enable_service.sh
)

for module in ${out_modules[@]}; do
    source $MODULEPATH$module
done

for sv in ${SERVICES[@]}; do
    check_enable_service $sv $OUTPUTDIR $PROJECT
done

make_raw_log_dir $OUTPUTDIR $OUTPUT

for policies in $(gcloud compute security-policies list --project $PROJECT | awk 'NR>1{print $1}'); do
    gcloud compute security-policies describe --project $PROJECT --format=json $policies > $OUTPUTDIR/json/armor/$policies-$PROJECT.json
done
