#!/bin/sh

echo "get vpn tunnel"
PROJECT=$1
OUTPUTDIR=$2
OUTPUT=vpn_tunnel
SERVICES=(
    compute.googleapis.com
)
CSVHEADER="name,project,ikeVersion,peerGcpGateway,peerIp,region,vpnGateway,vpnGatewayInterface"
MODULEPATH="./common/"

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

declare -a vpn_tunnels=($(gcloud compute vpn-tunnels list --project $PROJECT | awk 'NR>1{print $1}'))
declare -a regions=($(gcloud compute vpn-tunnels list --project $PROJECT | awk 'NR>1{print $2}'))

count=0
while [ $count -lt ${#vpn_tunnels[@]} ]; do
    gcloud compute vpn-tunnels describe --format json --project $PROJECT --region ${regions[$count]} ${vpn_tunnels[$count]} |\
        tee -a $OUTPUTDIR/json/$OUTPUT/${vpn_tunnels[$count]}-$PROJECT.json | \
        jq -r -c '[.name,"'$PROJECT'",.ikeVersion,.peerGcpGateway,.peerIp,.region,.vpnGateway,.vpnGatewayInterface] | @csv' | \
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
    count=$(( $count + 1 ))
done
