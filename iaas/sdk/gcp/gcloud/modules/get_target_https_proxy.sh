#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=https_proxy
CSVHEADER="name,project,urlMap,quicOverride,sslCertificates"
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

https_targets=$(gcloud compute target-https-proxies list --project $PROJECT | awk 'NR>1{print $1}')

for id in ${https_targets[@]}; do
    gcloud compute target-https-proxies describe --format json --project $PROJECT $id |\
        tee $OUTPUTDIR/json/$OUTPUT/$id-$PROJECT.json |\
        jq -r -c '[.name, "'$PROJECT'",.urlMap,.quicOverride,.sslCertificates[]]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
done
