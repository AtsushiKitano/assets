#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=forwarding_rule
CSVHEADER="name,project,IPProtocol,IPAddress,backendService,loadBalancingScheme,network,networkTier,region,serviceName,subnetwork,ports"
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

declare -a forwarding_rules_name=($(gcloud compute forwarding-rules list --project $PROJECT | awk 'NR>1{print $1}'))
declare -a forwarding_rules_region=($(gcloud compute forwarding-rules list --project $PROJECT | awk 'NR>1{print $2}'))


count=0

while [ $count -lt ${#instance_groups_name[@]} ]; do
    gcloud compute forwarding-rules describe --region ${forwarding_rules_region[$count]} --project $PROJECT --format json ${forwarding_rules_name[$count]} |\
        tee $OUTPUTDIR/json/$OUTPUT/${forwarding_rules_name[$count]}-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'",.IPProtocol,.IPAddress,.backendService,.loadBalancingScheme,.network,.networkTier,.region,.serviceName,.subnetwork,.ports[]]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
    count=$(( $count + 1 ))
done
