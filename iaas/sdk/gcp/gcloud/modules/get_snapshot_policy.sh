#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=snapshot
CSVHEADER="name,project,region,maxRetentionDays,onSourceDiskDelete,daysInCycle,duration,startTime"
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


declare -a snapshots=($(gcloud compute resource-policies list --project $PROJECT --format json | jq -r -c '.[]| .name'))
declare -a regions=($(gcloud compute resource-policies list --project $PROJECT --format json | jq -r -c '.[]| .region'))

count=0
while [ $count -lt ${#snapshots[@]} ]; do
    gcloud compute resource-policies describe --format json --region ${regions[$count]} --project $PROJECT ${snapshots[$count]} |\
        tee $OUTPUTDIR/json/$OUTPUT/${snapshots[$count]}-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'",.region,.snapshotSchedulePolicy.retentionPolicy.maxRetentionDays,.snapshotSchedulePolicy.retentionPolicy.onSourceDiskDelete,.snapshotSchedulePolicy.schedule.dailySchedule.daysInCycle, .snapshotSchedulePolicy.schedule.dailySchedule.duration, .snapshotSchedulePolicy.schedule.dailySchedule.startTime]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv

    count=$(( $count + 1 ))
done
