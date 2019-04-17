#!/bin/bash
APPLICATION_NAME=$1
DEPLOYMENT_ENV=$2
OUTPUT_DIR=$(dirname ${BASH_SOURCE[0]})

#Setup port forwarding from the remote cluster's PostgreSQL pod to this Jenkins slave
PG_POD=$(oc get pods -n ${APPLICATION_NAME}-${DEPLOYMENT_ENV} -l deploymentConfig=${APPLICATION_NAME}-mysql | grep "${APPLICATION_NAME}-[a-zA-Z0-9\\-]*" -o)
nohup oc port-forward $PG_POD 3306:3306  -n ${APPLICATION_NAME}-${DEPLOYMENT_ENV}  >  ${OUTPUT_DIR}/forwarding.log 2>&1 &
for i in {1..60}
do
  sleep 5
  cat ${OUTPUT_DIR}/forwarding.log
  if fgrep --quiet "Forwarding from" ${OUTPUT_DIR}/forwarding.log
  then
      exit 0
  fi
done
exit -1
