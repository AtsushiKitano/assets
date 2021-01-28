#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=memorystore
CSVHEADER="name,project,tier,memorySizeGb,redisVersion,locationId,authorizedNetwork,connectMode,port"
MODULEPATH="./common/"

SERVICES=(
    redis.googleapis.com
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

REGIONS=$(gcloud compute regions list |awk 'NR>1{print $1}')

for region in ${REGIONS[@]}; do
    dbs=$(gcloud redis instances list --region $region |awk 'NR>1{print $1}')

    for db in ${dbs[@]}; do
        gcloud redis instances describe --region $region --format json $db |\
            tee $OUTPUTDIR/json/$OUTPUT/$db-$PROJECT.json |\
            jq -r -c '[.name,"'$PROJECT'",.tier,.memorySizeGb,.redisVersion,.locationId,.authorizedNetwork,.connectMode,.port]|@csv' |\
            sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
    done
done
