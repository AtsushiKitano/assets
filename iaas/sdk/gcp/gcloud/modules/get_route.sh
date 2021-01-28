#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=route
CSVHEADER="name,project,destRange,network,priority"
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


for route in $(gcloud compute routes list --project $PROJECT | awk 'NR>1{print $1}'); do
    gcloud compute routes describe --project $PROJECT --format=json $route | \
        tee $OUTPUTDIR/json/route/$route-$PROJECT.json | jq -r '[.name,"'$PROJECT'",.destRange,.network,.priority]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
done

