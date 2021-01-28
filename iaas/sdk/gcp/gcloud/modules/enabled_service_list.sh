#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=service_list

out_modules=(
    ./common/make_output_dir.sh \
        )

for module in ${out_modules[@]}; do
    source $module
done

make_raw_log_dir $OUTPUTDIR $OUTPUT

gcloud services list --enabled --project $PROJECT | awk 'NR>1{print $1}' > $OUTPUTDIR/json/$OUTPUT/$PROJECT.txt
