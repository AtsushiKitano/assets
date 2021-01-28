#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=gce_disk
CSVHEADER="name,project,zone,size,sourceImage"
MODULEPATH="./common/"

SERVICES=(
    cloudbuild.googleapis.com
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

declare -a disks=($(gcloud compute disks list --project $PROJECT | awk 'NR>1{print $1}'))
declare -a zones=($(gcloud compute disks list --project $PROJECT | awk 'NR>1{print $2}'))

make_header $CSVHEADER $OUTPUTDIR $OUTPUT

count=0
while [ $count -lt ${#disks[@]} ]; do
    gcloud compute disks describe --format json --zone ${zones[$count]} --project $PROJECT ${disks[$count]}  | \
        tee -a $OUTPUTDIR/json/gce_disk/${disks[$count]}-$PROJECT.json | \
        jq -r -c '[.name,"'$PROJECT'",.zone,.sizeGb,.sourceImage] | @csv' | \
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
    count=$(( $count + 1 ))
done

