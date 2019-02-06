#!/usr/bin/env bash
echo -n "Waiting for the Entando Deployment $1 to start ... "
sleep 2
while [ -z "$(oc get pods -l deploymentConfig=$1 2>/dev/null)" ]
do
    echo -n "."
    sleep 2
done
echo
echo "Deployment started:"
oc get pods -l deploymentConfig=$1

echo -n "Waiting for the $1 containers to be created... "

while [ -z "$(oc get pods -l deploymentConfig=$1  -o=jsonpath='{.items[?(@.status.containerStatuses[0])]}')" ]
do
    echo -n "."
    sleep 2
done
echo
echo "Containers created:"
oc get pods -l deploymentConfig=$1

echo -n "Waiting for the $1 containers to start successfully ... "
while [ -n "$(oc get pods -l deploymentConfig=$1  -o=jsonpath='{.items[?(@.status.containerStatuses[0].ready==false)]}')" ]
do
    echo -n "."
    sleep 2
done
echo
echo "Deployment completed:"
oc get pods -l deploymentConfig=$1
