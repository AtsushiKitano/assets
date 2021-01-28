#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=build_trigger
CSVHEADER="name,project,branchName,projectId,repoName,filename"
MODULEPATH="./common/"

SERVICES=(
    cloudbuild.googleapis.com
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

triggername=$(gcloud alpha builds triggers list --format=json --project $PROJECT | jq -r -c '.[]|.name')


for name in ${triggername[@]}; do
    gcloud alpha builds triggers describe $name --project=$PROJECT --format=json |\
        tee $OUTPUTDIR/json/$OUTPUT/$name-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'" ,.triggerTemplate.branchName, .triggerTemplate.projectId, .triggerTemplate.repoName ,.filename] | @csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
done

