#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=instance_group
CSVHEADER="name,project,network,size,subnetwork,zone"
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

declare -a instance_groups_name=($(gcloud compute instance-groups list --project $PROJECT | awk 'NR>1{print $1}'))
declare -a instance_groups_scope=($(gcloud compute instance-groups list --project $PROJECT | awk 'NR>1{print $3}'))
declare -a instance_groups_location=($(gcloud compute instance-groups list --project $PROJECT | awk 'NR>1{print $2}'))

count=0

while [ $count -lt ${#instance_groups_name[@]} ]; do
    gcloud compute instance-groups describe --${instance_groups_scope[$count]} ${instance_groups_location[$count]} --project $PROJECT --format json ${instance_groups_name[$count]} |\
        tee $OUTPUTDIR/json/$OUTPUT/${instance_groups_name[$count]}-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'",.network,.size,.subnetwork,.zone]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
    count=$(( $count + 1 ))
done
