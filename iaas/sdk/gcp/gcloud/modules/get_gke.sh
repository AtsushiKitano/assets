#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUTCL=gke_cluster
OUTPUTND=gke_node
CSVHEADERCL="name,project,network,subnetwork,endpoint,clusterIpv4Cidr,currentMasterVersion,currentNodeCount,currentNodeVersion,databaseEncryption.state,defaultMaxPodsConstraint.maxPodsPerNode,nodeConfig.diskSizeGb,nodeConfig.diskType,nodeConfig.imageType,nodeConfig.machineType,locations"
CSVHEADERND="name,project,imageType,diskSizeGb,diskType,machineType,serviceAccount,podIpv4CidrSize,maxSurge,version"
MODULEPATH="./common/"

SERVICES=(
    container.googleapis.com
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

for dir in $OUTPUTCL $OUTPUTND ; do
    make_raw_log_dir $OUTPUTDIR $dir
done

make_header $CSVHEADERCL $OUTPUTDIR $OUTPUTCL
make_header $CSVHEADERND $OUTPUTDIR $OUTPUTND


declare -a clusters=($(gcloud container clusters list --project $PROJECT | awk 'NR>1{print $1}'))
declare -a regions=($(gcloud container clusters list --project $PROJECT | awk 'NR>1{print $2}'))

count=0

while [ $count -lt ${#clusters[@]} ]; do
    gcloud container clusters describe --project $PROJECT --region ${regions[$count]} --format=json ${clusters[$count]} |\
        tee $OUTPUTDIR/json/$OUTPUTCL/${clusters[$count]}-$PROJECT.json | \
        jq -r -c '[.name,"'$PROJECT'",.network, .subnetwork ,.endpoint,.clusterIpv4Cidr,.currentMasterVersion,.currentNodeCount,.currentNodeVersion,.databaseEncryption.state,.defaultMaxPodsConstraint.maxPodsPerNode, .nodeConfig.diskSizeGb, .nodeConfig.diskType, .nodeConfig.imageType, .nodeConfig.machineType, .locations[]] | @csv' | \
            sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUTCL.csv

    nodes=$(gcloud container node-pools list --project $PROJECT --cluster ${clusters[$count]} --region ${regions[$count]} | awk 'NR>1{print $1}')

    for node in ${nodes[@]}; do
        gcloud container node-pools describe --project $PROJECT  --cluster ${clusters[$count]} --region ${regions[$count]} $node --format=json |\
            tee $OUTPUTDIR/json/$OUTPUTND/$node-${clusters[$count]}-$PROJECT.json |\
            jq -r -c '[.name,"'$PROJECT'",.config.imageType,.config.diskSizeGb, .config.diskType, .config.machineType, .config.serviceAccount, .podIpv4CidrSize, .upgradeSettings.maxSurge, .version]|@csv' |\
            sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUTND.csv
    done

    count=$(( $count + 1 ))
done

