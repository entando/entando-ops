#!/usr/bin/env bash
function calculate_mirror_url(){
    NEXUS_URL="$( oc describe route $nexus -n openshift|grep -oP "(?<=Requested\sHost:\t\t)[^ ]+")"
    if [ ! -z $NEXUS_URL ]; then
        NEXUS_URL="http://$NEXUS_URL/repository/maven-public"
    fi
    echo $NEXUS_URL
}
