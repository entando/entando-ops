#!/usr/bin/env bash
source $(dirname $0)/common.sh
function calculate_mirror_url(){
    NEXUS_URL="$( oc describe route $nexus -n openshift|grep -oP "(?<=Requested\sHost:\t\t)[^ ]+")"
    if [ ! -z $NEXUS_URL ]; then
        NEXUS_URL="http://$NEXUS_URL/repository/maven-public"
    else
        NEXUS_URL="http://172.17.0.4:8081/repository/maven-public"
    fi
    echo $NEXUS_URL
}
echo "This script installs Nexus"
#oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/nexus-with-entando-dependencies.json
#oc process -f $ENTANDO_OPS_HOME/Openshift/templates/nexus-with-entando-dependencies.yml \
#  -p SERVICE_NAME="nexus" \
#    | oc replace --force -f -
oc process -f https://raw.githubusercontent.com/OpenShiftDemos/nexus/master/nexus3-persistent-template.yaml \
  -p SERVICE_NAME="nexus" \
    | oc replace --force -f -

