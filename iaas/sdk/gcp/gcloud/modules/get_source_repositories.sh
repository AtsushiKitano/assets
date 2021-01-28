#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=source_repositories
CSVHEADER="name,project,size,url"
MODULEPATH="./common/"

SERVICES=(
    sourcerepo.googleapis.com
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

for csr in $(gcloud source repos list --project=$PROJECT | awk 'NR>1{print $1}') ; do
    gcloud source repos describe --project=$PROJECT --format=json $csr |\
        tee $OUTPUTDIR/json/$OUTPUT/$csr-$PROJECT.json |\
        jq -c -r '[.name, "'$PROJECT'",.size, .url] | @csv' | \
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
done
