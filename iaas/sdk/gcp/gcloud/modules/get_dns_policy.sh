#!/bin/sh

# PROJECT=$1
# OUTPUTDIR=$2
# OUTPUT=dns_policy
# SERVICE=dns.googleapis.com

# grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

# if [ $? != 0 ]; then
#     exit 0
# fi

# if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
#     mkdir $OUTPUTDIR/json/$OUTPUT
# fi

# echo "name,dnsName,visibility, nameServers" > $OUTPUT-$PROJECT.csv
# policies=$(gcloud dns policies list --project $PROJECT | awk 'NR>1{print $1}')
# for pl in ${policies[@]}; do
#     gcloud dns policies describe --project $PROJECT --format=json $pl |\
#         tee -a $OUTPUTDIR/$OUTPUT-$PROJECT.json | \
#         jq -r -c '[.name, .dnsName, .visibility, .nameServers[] ] |@csv' | \
#         sed -e 's/"//g' >> $OUTPUTDIR/$OUTPUT-$PROJECT.csv
# done

