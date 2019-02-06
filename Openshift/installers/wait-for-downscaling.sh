#!/usr/bin/env bash
echo -n "Waiting to downscale $1 to 0 ... "
#While there are pods against the deployment
while [ -n "$(oc get pods -l deploymentConfig=$1 2>/dev/null)" ]
do
    echo -n "."
    sleep 2
done
echo
