#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=instance_template
CSVHEADER="name,project,.properties.disks.autoDelete,.properties.disks.boot,.properties.disks.deviceName,.properties.disks.initializeParams.diskSizeGb,.properties.disks.initializeParams.diskType,.properties.disks.initializeParams.sourceImage,.properties.disks.mode,.properties.disks.type,.properties.machineType,.properties.networkInterfaces.network,.properties.networkInterfaces.subnetwork,.properties.scheduling.automaticRestart,.properties.scheduling.onHostMaintenance,.properties.scheduling.preemptible,.properties.serviceAccounts.email,.properties.serviceAccounts.scopes,.properties.tags.items"
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

instance_templates_list=$(gcloud compute instance-templates list --project $PROJECT | awk 'NR>1{print $1}')

for it in ${instance_templates_list[@]}; do
    gcloud compute instance-templates describe --project $PROJECT --format json $it |\
        tee $OUTPUTDIR/json/$OUTPUT/$it-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'",.properties.disks[].autoDelete,.properties.disks[].boot,.properties.disks[].deviceName,.properties.disks[].initializeParams.diskSizeGb, .properties.disks[].initializeParams.diskType,.properties.disks[].initializeParams.sourceImage,.properties.disks[].mode,.properties.disks[].type,.properties.machineType,.properties.networkInterfaces[].network,.properties.networkInterfaces[].subnetwork,.properties.scheduling.automaticRestart,.properties.scheduling.onHostMaintenance,.properties.scheduling.preemptible,.properties.serviceAccounts[].email,.properties.serviceAccounts[].scopes[],.properties.tags.items[]] |@csv'|\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
done
