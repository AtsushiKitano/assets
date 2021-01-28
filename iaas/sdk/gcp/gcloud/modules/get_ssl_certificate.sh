#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=ssl_certificate
SERVICE=compute.googleapis.com
CSVHEADER="name,project,type,subjectAlternativeNames"
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

ssls=$(gcloud compute ssl-certificates list --project $PROJECT | awk 'NR>1{print $1}')

for ssl in ${ssls[@]}; do
    gcloud compute ssl-certificates describe --project $PROJECT --format jobs $ssl |\
        tee $OUTPUTDIR/json/$OUTPUT/$ssl-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'",.type,.subjectAlternativeNames[]]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
done
