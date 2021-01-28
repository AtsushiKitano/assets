#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=gce
CSVHEADER="name,project,zone"
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

declare -a gces=($(gcloud compute instances list --project $PROJECT | awk 'NR>1{print $1}'))
declare -a zones=($(gcloud compute instances list --project $PROJECT | awk 'NR>1{print $2}'))

count=0
while [ $count -lt ${#gces[@]} ]; do
    gcloud compute instances describe --format json --zone ${zones[$count]} --project $PROJECT ${gces[$count]} | \
        tee -a $OUTPUTDIR/json/$OUTPUT/${gces[$count]}-$PROJECT.json | \
        jq -r -c '[.name,"'$PROJECT'",.zone] | @csv' | \
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
    count=$(( $count + 1 ))
done
