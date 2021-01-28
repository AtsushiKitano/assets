#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=vpc_network
CSVHEADER="name,project,autoCreateSubnetworks,x_gcloud_bgp_routing_mode,x_gcloud_subnet_mode"
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


NETWORKS=$(gcloud compute networks list --project=$PROJECT | awk 'NR>1{print $1}')
for nw in ${NETWORKS[@]}; do
    gcloud compute networks describe $nw --format=json --project=$PROJECT |\
        tee $OUTPUTDIR/json/$OUTPUT/$nw-$PROJECT.json | \
        jq -r -c '[.name,"'$PROJECT'",.autoCreateSubnetworks, .x_gcloud_bgp_routing_mode, .x_gcloud_subnet_mode] | @csv'| \
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
done
