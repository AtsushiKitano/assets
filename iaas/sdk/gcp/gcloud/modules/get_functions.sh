#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=functions
CSVHEADER="name,project,availableMemoryMb,runtime,timeout,entryPoint,eventType,resource,service,ingressSettings,serviceAccountEmail,sourceRepository,url,status"
MODULEPATH="./common/"

SERVICES=(
    cloudfunctions.googleapis.com
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

declare -a functions=($(gcloud functions list --project=$PROJECT |awk 'NR>1{print $1}'))
declare -a regions=($(gcloud functions list --project=$PROJECT|awk 'NR>1{print $5}'))

count=0
while [ $count -lt ${#functions[@]} ]; do
    gcloud functions describe --region ${regions[$count]} --project $PROJECT --format=json ${functions[$count]} |\
        tee $OUTPUTDIR/json/$OUTPUT/${functions[$count]}-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'",.entryPoint, .availableMemoryMb, .timeout, .runtime, .eventTrigger.eventType, .eventTrigger.resource]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
    count=$(( $count + 1 ))
done

