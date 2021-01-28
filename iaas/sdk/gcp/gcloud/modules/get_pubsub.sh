#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUTSUB=pubsub_subscription
OUTPUTTOP=pubsub_topics
CSVHEADERTOP="name,project"
CSVHEADERSUB="name,project,topic,ackDeadlineSeconds,messageRetentionDuration"
MODULEPATH="./common/"

SERVICES=(
    pubsub.googleapis.com
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

for dir in $OUTPUTTOP $OUTPUTSUB ;do
    make_raw_log_dir $OUTPUTDIR $dir
done

make_header $CSVHEADERTOP $OUTPUTDIR $OUTPUTTOP
make_header $CSVHEADERSUB $OUTPUTDIR $OUTPUTSUB


subscriptions=$(gcloud pubsub subscriptions list --format=json --project=$PROJECT | jq -r -c '.[]|.name')

for sub in ${subscriptions[@]}; do
    tmp=$(echo $sub | tr '/' ' ')
    declare -a tmparray=($tmp)
    filename=${tmparray[$((${#tmparray[@]} - 1))]}

    gcloud pubsub subscriptions describe --project $PROJECT --format=json $sub |\
        tee $OUTPUTDIR/json/$OUTPUTSUB/$filename-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'",.topic,.ackDeadlineSeconds,.messageRetentionDuration]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUTSUB.csv
done

topics=$(gcloud pubsub topics list --format=json --project $PROJECT | jq -r -c '.[]|.name')

for tp in ${topics[@]};do
    gcloud pubsub topics describe --project=$PROJECT --format json $tp |\
        jq -r -c '[.name, "'$PROJECT'"]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUTTOP.csv
done
