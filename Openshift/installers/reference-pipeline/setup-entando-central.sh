#!/usr/bin/env bash
source $(dirname $0)/../common.sh
APPLICATION_NAME=entando-central

function prepare_source_secret(){
    echo "Creating the BitBucket source secret."
    if [ -n "${BITBUCKET_USERNAME}" ]; then
      cat <<EOF | oc replace --force --grace-period 60 -f -
apiVersion: v1
kind: Secret
metadata:
  name: ${APPLICATION_NAME}-source-secret
  labels:
    application: "${APPLICATION_NAME}"
    credential.sync.jenkins.openshift.io: "true"
stringData:
  username: ${BITBUCKET_USERNAME}
  password: ${BITBUCKET_PASSWORD}
EOF
  fi
}

function prepare_db_secret(){
  echo "Creating the Entando DB Secret for the $1 environment."
  PASSWORD_VAR_NAME=${1^^}_DB_PASSWORD
  ADMIN_PASSWORD_VAR_NAME=${1^^}_DB_ADMIN_PASSWORD
  if [ -f passwords.txt ]; then
  # read previously generated passwords from file
    source passwords.txt
  fi
  if [ -z "${!PASSWORD_VAR_NAME}" ]; then
  # make sure that the passwords for this environment is persisted to the file too
      declare ${PASSWORD_VAR_NAME}=asdfasdf #$(openssl rand -base64 24)
      declare ${ADMIN_PASSWORD_VAR_NAME}=asdfasdfa #$(openssl rand -base64 24)
      cat <<EOF >> passwords.txt
${1^^}_DB_PASSWORD=${!PASSWORD_VAR_NAME}
${1^^}_DB_ADMIN_PASSWORD=${!ADMIN_PASSWORD_VAR_NAME}
EOF
  fi
  oc process -f $ENTANDO_OPS_HOME/Openshift/templates/reference-pipeline/entando-db-secret.yml \
            -p APPLICATION_NAME="${APPLICATION_NAME}" \
            -p SECRET_NAME="${APPLICATION_NAME}-db-secret-$1" \
            -p PASSWORD="${!PASSWORD_VAR_NAME}" \
            -p DB_HOSTNAME="${APPLICATION_NAME}-postgresql.${APPLICATION_NAME}-$1.svc" \
            -p ADMIN_PASSWORD="${!ADMIN_PASSWORD_VAR_NAME}" \
          |  oc replace --force --grace-period 60  -f -
  oc process -f $ENTANDO_OPS_HOME/Openshift/templates/reference-pipeline/entando-db-file-secret.yml \
            -p APPLICATION_NAME="${APPLICATION_NAME}" \
            -p SECRET_NAME="${APPLICATION_NAME}-db-file-secret-$1" \
            -p PASSWORD="${!PASSWORD_VAR_NAME}" \
            -p DB_HOSTNAME="${APPLICATION_NAME}-postgresql.${APPLICATION_NAME}-$1.svc" \
            -p ADMIN_PASSWORD="${!ADMIN_PASSWORD_VAR_NAME}" \
          |  oc replace --force --grace-period 60  -f -
}

function setup_entando_pipeline(){
  ./setup-entando-pipeline.sh $COMMAND --application-name=${APPLICATION_NAME} \
    --source-repository-url="https://bitbucket.org/entando/central-entando.git" \
    --source-repository-ref="EN-1904" \
    --image-stream-namespace=entando \
    --stage-db-secret="${APPLICATION_NAME}-db-secret-stage" \
    --prod-db-secret="${APPLICATION_NAME}-db-secret-prod"

}
if [[ $1 =~ -.* ]]; then
  echo "The first argument should be one of create/delete"
  exit -1
else
  COMMAND=$1
  shift
fi


case $COMMAND in
  populate)
      oc project ${APPLICATION_NAME}-build
      prepare_source_secret
      prepare_db_secret stage
      prepare_db_secret prod
      oc project ${APPLICATION_NAME}-stage
      prepare_db_secret stage
      oc project ${APPLICATION_NAME}-prod
      prepare_db_secret prod
  ;;
  clear)
      oc delete secrets -l application=${APPLICATION_NAME} -n ${APPLICATION_NAME}-build
      oc delete secrets -l application=${APPLICATION_NAME} -n ${APPLICATION_NAME}-stage
      oc delete secrets -l application=${APPLICATION_NAME} -n ${APPLICATION_NAME}-prod
  ;;
esac
setup_entando_pipeline
