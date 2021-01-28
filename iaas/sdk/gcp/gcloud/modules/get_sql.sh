#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=cloud_sql
CSVHEADER="name,project,gceZone,databaseVersion,serviceAccountEmailAddress,activationPolicy,availabilityType,backupRetentionSettings,backupRetentionretentionUnit,dataDiskSizeGb,dataDiskType"
MODULEPATH="./common/"

SERVICES=(
    sqladmin.googleapis.com
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

instances=$(gcloud sql instances list --project $PROJECT | awk 'NR>1{print $1}')


for instance in ${instances[@]}; do
    gcloud sql instances describe --project $PROJECT --format json $instance |\
        tee $OUTPUTDIR/json/$OUTPUT/$instance-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'",.gceZone,.databaseVersion,.serviceAccountEmailAddress,.settings.activationPolicy, .settings.availabilityType, .settings.backupConfiguration.backupRetentionSettings.retainedBackups, .settings.backupConfiguration.backupRetentionSettings.retentionUnit, .settings.dataDiskSizeGb, .settings.dataDiskType]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
done
