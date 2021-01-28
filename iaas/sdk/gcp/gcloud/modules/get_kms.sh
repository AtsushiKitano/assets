#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUTRING=kmsrings
OUTPUTKEY=keys
CSVHEADERRING="name,project,createTime"
CSVHEADERKEY="name,project,algorithm,generateTime,protectionLevel,primary.state,purpose,versionTemplate.algorithm,primary.protectionalLevel"
MODULEPATH="./common/"

LOCATION=(
    global
    asia-northeast1
)
SERVICES=(
    cloudkms.googleapis.com \
        )

MODULES=(
    make_file_name.sh \
        make_output_dir.sh \
        check_enable_service.sh \
        make_output_header.sh
)

for module in ${MODULES[@]}; do
    source $MODULEPATH$module
done

for sv in ${SERVICES[@]}; do
    check_enable_service $sv $OUTPUTDIR $PROJECT
done

for dir in $OUTPUTRING $OUTPUTKEY ; do
    make_raw_log_dir $OUTPUTDIR $dir
done

make_header $CSVHEADERRING $OUTPUTDIR $OUTPUTRING
make_header $CSVHEADERKEY $OUTPUTDIR $OUTPUTKEY

for local in ${LOCATION[@]}; do
    KEYRINGS=$(gcloud kms keyrings list --location $local --project $PROJECT | awk 'NR>1{print $1}')
    for kr in ${KEYRINGS[@]}; do
        filename=$(make_file_name $kr)
        gcloud kms keyrings describe $kr --project $PROJECT --format=json | \
            tee -a $OUTPUTDIR/json/$OUTPUTRING/$filename-$PROJECT.json | jq -r -c '[.name,"'$PROJECT'",.createTime] | @csv' | \
            sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUTRING.csv

        for key in $(gcloud kms keys list --keyring $kr --project $PROJECT | awk 'NR>1{print $1}') ; do
            filename=$(make_file_name $key)
            gcloud kms keys describe $key --project $PROJECT --format=json |\
                tee $OUTPUTDIR/json/$OUTPUTKEY/$filename-$PROJECT.json | \
                jq -r -c '[.name,"'$PROJECT'",.primary.algorithm, .primary.generateTime, .primary.protectionLevel, .primary.state, .purpose, .versionTemplate.algorithm, .versionTemplate.protectionalLevel] | @csv' |\
                sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUTKEY.csv
        done
    done
done

