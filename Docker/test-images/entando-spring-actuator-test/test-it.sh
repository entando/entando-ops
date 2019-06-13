#!/usr/bin/env bash
i=0
while [ "$i" -le "${MAX_ATTEMPTS:-10}" ]; do 
  if curl -v ${SPRING_BOOT_BASE_URL}/health|grep '\"status\":\"UP\"' ; then 
    exit 0 
  fi
  i=$(($i+1)) 
  sleep ${INTERVAL:-4}
done 
exit 1

