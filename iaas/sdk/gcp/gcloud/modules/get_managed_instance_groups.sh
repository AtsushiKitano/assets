#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=managed_instance_group
CSVHEADER=".name,project,.autoHealingPolicies.healthCheck,.autoHealingPolicies.initialDelaySec,.autoscaler.autoscalingPolicy.coolDownPeriodSec,.autoscaler.autoscalingPolicy.cpuUtilization.utilizationTarget,.autoscaler.autoscalingPolicy.maxNumReplicas,.autoscaler.autoscalingPolicy.minNumReplicas,.autoscaler.autoscalingPolicy.mode,.autoscaler.recommendedSize,.autoscaler.status,.baseInstanceName,.currentActions.abandoning,.currentActions.creating,.currentActions.creatingWithoutRetries,.currentActions.deleting,.currentActions.none,.currentActions.recreating,.currentActions.refreshing,.currentActions.restarting,.currentActions.verifying,.distributionPolicy.zones,.region,.status.autoscaler,.status.isStable,.status.stateful.hasStatefulConfig,.status.stateful.perInstanceConfigs.allEffective,.status.versionTarget.isReached,.targetSize,.updatePolicy.instanceRedistributionType,.updatePolicy.maxSurge.calculated,.updatePolicy.maxSurge.fixed,.updatePolicy.maxUnavailable.calculated,.updatePolicy.maxUnavailable.fixed,.updatePolicy.minimalAction,.updatePolicy.replacementMethod,.updatePolicy.type,.versions.targetSize.calculated"
MODULEPATH="./common/"

SERVICES=(
    compute.googleapis.com
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

# declare -a instance_groups_name=($(gcloud compute instance-groups managed list --project $PROJECT | awk 'NR>1{print $1}'))
# declare -a instance_groups_scope=($(gcloud compute instance-groups managed list --project $PROJECT | awk 'NR>1{print $3}'))
# declare -a instance_groups_location=($(gcloud compute instance-groups managed list --project $PROJECT | awk 'NR>1{print $2}'))

declare -a instance_groups_name=($(gcloud compute instance-groups managed list --project $PROJECT  --filter="region:asia-northeast1" | awk 'NR>1{print $1}'))

count=0

while [ $count -lt ${#instance_groups_name[@]} ]; do
    # gcloud compute instance-groups managed describe --${instance_groups_scope[$count]} ${instance_groups_location[$count]} --project $PROJECT --format json ${instance_groups_name[$count]} |\
        gcloud compute instance-groups managed describe --region asia-northeast1 --project $PROJECT --format json ${instance_groups_name[$count]} |\
        tee $OUTPUTDIR/json/$OUTPUT/${instance_groups_name[$count]}-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'",.autoHealingPolicies[].healthCheck,.autoHealingPolicies[].initialDelaySec,.autoscaler.autoscalingPolicy.coolDownPeriodSec,.autoscaler.autoscalingPolicy.cpuUtilization.utilizationTarget,.autoscaler.autoscalingPolicy.maxNumReplicas,.autoscaler.autoscalingPolicy.minNumReplicas,.autoscaler.autoscalingPolicy.mode,.autoscaler.recommendedSize,.autoscaler.status,.baseInstanceName,.currentActions.abandoning,.currentActions.creating,.currentActions.creatingWithoutRetries,.currentActions.deleting,.currentActions.none,.currentActions.recreating,.currentActions.refreshing,.currentActions.restarting,.currentActions.verifying,.distributionPolicy.zones[].zone,.region,.status.autoscaler,.status.isStable,.status.stateful.hasStatefulConfig,.status.stateful.perInstanceConfigs.allEffective,.status.versionTarget.isReached,.targetSize,.updatePolicy.instanceRedistributionType,.updatePolicy.maxSurge.calculated,.updatePolicy.maxSurge.fixed,.updatePolicy.maxUnavailable.calculated,.updatePolicy.maxUnavailable.fixed,.updatePolicy.minimalAction,.updatePolicy.replacementMethod,.updatePolicy.type,.versions[].targetSize.calculated] |@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
    count=$(( $count + 1 ))
done
