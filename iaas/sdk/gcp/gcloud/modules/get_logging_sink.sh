#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=logging_sink
CSVHEADER="name,project,filter,destination"
MODULEPATH="./common/"

SERVICES=(
    logging.googleapis.com
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

sinks=$(gcloud logging sinks list --project $PROJECT | awk 'NR>1{print $1}')

echo $sinks
for sink in ${sinks[@]}; do
    gcloud logging sinks describe --project $PROJECT --format json $sink |\
        tee $OUTPUTDIR/json/$OUTPUT/$sink-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'", .filter, .destination] | @csv' | sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
done
