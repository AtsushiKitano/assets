#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=dns_record
CSVHEADER="name,project,dnsName,visibility,nameServers"
MODULEPATH="./common/"

SERVICES=(
    dns.googleapis.com
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
records=$(gcloud dns managed-zones list --project $PROJECT | awk 'NR>1{print $1}')

for rc in ${records[@]}; do
    gcloud dns managed-zones describe --project $PROJECT --format=json $rc |\
        tee $OUTPUTDIR/json/$OUTPUT/$$rc-$PROJECT.json | \
        jq -r -c '[.name,"'$PROJECT'",.dnsName, .visibility, .nameServers[] ] |@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
done
