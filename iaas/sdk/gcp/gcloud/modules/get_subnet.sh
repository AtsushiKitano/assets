#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=subnet
SERVICES=(
    compute.googleapis.com
)
CSVHEADER="name,project,network,region,privateIpGoogleAccess,purpose,gatewayAddress"
MODULEPATH="./common/"

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

declare -a subnets=($(gcloud compute networks subnets list --project $PROJECT | awk 'NR>1{print $1}'))
declare -a regions=($(gcloud compute networks subnets list --project $PROJECT | awk 'NR>1{print $2}'))

count=0
while [ $count -lt ${#subnets[@]} ]; do
    gcloud compute networks subnets describe --format json --region ${regions[$count]} --project $PROJECT  ${subnets[$count]} | \
        tee $OUTPUTDIR/json/$OUTPUT/${subnets[$count]}-$PROJECT.json | \
        jq -r -c '[.name,"'$PROJECT'",.network,.region,.privateIpGoogleAccess,.purpose,.gatewayAddress] | @csv' | \
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
    count=$(( $count + 1 ))
done
