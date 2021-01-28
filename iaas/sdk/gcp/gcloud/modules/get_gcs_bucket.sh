#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=gcs_buckets
OBJECTS=gcs_objects
MODULEPATH="./common/"

SERVICES=(
    compute.googleapis.com
    storage-api.googleapis.com
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
make_raw_log_dir $OUTPUTDIR $OBJECTS


# bkts=$(gsutil ls -p $PROJECT)
# echo "name" > $OUTPUTDIR/csv/$OUTPUT-$PROJECT.csv
# for bk in ${bkts[@]}; do
#     echo $bk  | tr -d 'gs://' >> $OUTPUTDIR/csv/$OUTPUT-$PROJECT.csv
#     gsutil ls -L -b $bk > $OUTPUTDIR/json/gcs/$bk-$PROJECT.txt
# done
