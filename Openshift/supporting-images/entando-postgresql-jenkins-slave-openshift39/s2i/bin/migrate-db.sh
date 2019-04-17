#!/usr/bin/env bash
NAMESPACE=$1
IMAGE=$2
ENTANDO_DB_FILE_SECRET=$3
oc delete pod migrate-db --ignore-not-found=true -n ${NAMESPACE}
oc run migrate-db --image=notused \
  -it --replicas=1  --restart=Never -n ${NAMESPACE} --overrides="
{
        \"spec\": {
            \"containers\": [
                {
                    \"command\": [
                        \"/entando-common/init-db-from-deployment.sh\"
                    ],
                    \"image\": \"${IMAGE}\",
                    \"name\": \"migrate-db\",
                    \"volumeMounts\": [{
                        \"mountPath\": \"/etc/eap-env-files\",
                        \"name\": \"eap-env-files\",
                        \"readOnly\":true
                    }],
                    \"env\":[{
                            \"name\": \"ENV_FILES\",
                            \"value\": \"/etc/eap-env-files/datasources.env\"
                    }]
                }
            ],
            \"volumes\": [
                {
                    \"name\": \"eap-env-files\",
                    \"secret\":{
                         \"secretName\": \"${ENTANDO_DB_FILE_SECRET}\"
                    }
                }
            ]
        }
}
"