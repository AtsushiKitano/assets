#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=vpn_gateway
SERVICES=(
    compute.googleapis.com
)
CSVHEADER="name,project,network,region"
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

declare -a vpn_gws=($(gcloud compute vpn-gateways list --project $PROJECT | awk 'NR>1{print $1}'))
declare -a regions=($(gcloud compute vpn-gateways list --project $PROJECT | awk 'NR>1{print $5}'))

count=0
while [ $count -lt ${#vpn_gws[@]} ]; do
    gcloud compute vpn-gateways describe --format json --project $PROJECT --region ${regions[$count]} ${vpn_gws[$count]} |\
        tee -a $OUTPUTDIR/json/$OUTPUT/${vpn_gws[$count]}-$PROJECT.json | \
        jq -r -c '[.name,"'$PROJECT'",.network,.region] | @csv' | \
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
    count=$(( $count + 1 ))
done
