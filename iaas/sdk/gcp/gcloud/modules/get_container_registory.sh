#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=container_registory
CSVHEADER="name,project,registry,repository"
MODULESDIRPATH="./common/"
SERVICES=(
    containerregistry.googleapis.com
)

out_modules=(
    make_output_dir.sh \
        check_enable_service.sh \
        make_output_header.sh \
        make_file_name.sh
)

for module in ${out_modules[@]}; do
    source $MODULESDIRPATH$module
done

for sv in ${SERVICES[@]}; do
    check_enable_service $sv $OUTPUTDIR $PROJECT
done

make_raw_log_dir $OUTPUTDIR $OUTPUT
make_header $CSVHEADER $OUTPUTDIR $OUTPUT

containers=$(gcloud container images list --project $PROJECT | awk 'NR>1{print $1}')

for container in ${containers[@]}; do
    filename=$(make_file_name $container)
    gcloud container images describe --project $PROJECT --format json $container |\
        tee $OUTPUTDIR/json/$OUTPUT/$filename-$PROJECT.json |\
        jq -r -c '["'$filename'","'$PROJECT'",.image_summary.registry,.image_summary.repository]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
done
