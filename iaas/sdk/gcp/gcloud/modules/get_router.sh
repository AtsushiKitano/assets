#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUTR=cloud_router
OUTPUTN=cloud_nat
CSVHEADERR="name,project,network.region"
CSVHEADERN="name,natIpAllocateOption,sourceSubnetworkIpRangesToNat,logConfig.enable,logConfig.filter"
MODULEPATH="./common/"

SERVICE=compute.googleapis.com
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

for dir in $OUTPUTR $OUTPUTN; do
    make_raw_log_dir $OUTPUTDIR $dir
done

make_header $CSVHEADERR $OUTPUTDIR $OUTPUTR
make_header $CSVHEADERN $OUTPUTDIR $OUTPUTN

declare -a routers=($(gcloud compute routers list --project $PROJECT | awk 'NR>1{print $1}'))
declare -a regions=($(gcloud compute routers list --project $PROJECT | awk 'NR>1{print $2}'))

count=0
while [ $count -lt ${#routers[@]} ];do
    gcloud compute routers describe --region ${regions[$count]} --format json --project $PROJECT ${routers[$count]} |\
        tee $OUTPUTDIR/json/$OUTPUTR/${routers[$count]}-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'",.network,.region]|@csv' | \
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUTR.csv

    gcloud compute routers describe --region ${regions[$count]} --project $PROJECT ${routers[$count]} | grep nats:
    if [ $? == 0 ]; then
        nats=$(gcloud compute routers nats list --project $PROJECT --region ${regions[$count]} --router ${routers[$count]} | awk 'NR>1{print $1}')

        for nat in ${nats[@]}; do
            gcloud compute routers nats describe --project $PROJECT --region ${regions[$count]} --router ${routers[$count]} --format json $nat | \
                tee $OUTPUTDIR/json/$OUTPUTN/$nat-$PROJECT.json |\
                jq -r -c '[.name,"'$PROJECT'",.natIpAllocateOption,.sourceSubnetworkIpRangesToNat,.logConfig.enable,.logConfig.filter]|@csv' |\
                sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUTN.csv
        done
    fi

    count=$(( $count + 1 ))
done
