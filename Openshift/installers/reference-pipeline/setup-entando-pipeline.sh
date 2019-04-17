#!/usr/bin/env bash
export ENTANDO_OPS_HOME=$(dirname $(dirname $(dirname $(dirname $(realpath $BASH_SOURCE[0])))))
echo $ENTANDO_OPS_HOME

function determine_db_admin(){
    case "${1}" in
        "postgresql")
          echo "postgres"
        ;;
        "mysql")
          echo "root"
        ;;
    esac
}
function determine_db_port(){
    case "${1}" in
        "postgresql")
          echo "5432"
        ;;
        "mysql")
          echo "3306"
        ;;
    esac
}

function determine_db_template(){
    case "${1}" in
        "postgresql")
          echo "entando-postgresql95-deployment.yml"
        ;;
        "mysql")
          echo "entando-mysql57-deployment.yml"
        ;;
    esac
}

function read_config(){
  source $(dirname $0)/clear-vars.sh
  if [ -f $CONFIG_DIR/$1.conf ]; then
    source $CONFIG_DIR/$1.conf
  else
    echo "Config file for $1 not found. Expected file: $CONFIG_DIR/$1.conf)"
    exit -1
  fi
}
function log_into_prod_cluster(){
  read_config build
  oc login -u $PRODUCTION_CLUSTER_USERNAME -p $PRODUCTION_CLUSTER_PASSWORD $PRODUCTION_CLUSTER_URL
  if [[ -z "${PRODUCTION_CLUSTER_TOKEN}" ]]; then
    export PRODUCTION_CLUSTER_TOKEN=$(oc whoami -t)
  fi
}

function log_into_stage_cluster(){
  read_config build
  oc login -u $STAGE_CLUSTER_USERNAME -p $STAGE_CLUSTER_PASSWORD $STAGE_CLUSTER_URL
}

function create_stage_projects(){
    log_into_stage_cluster
    oc new-project $APPLICATION_NAME-build
    oc new-project $APPLICATION_NAME-stage
    oc policy add-role-to-group system:image-puller system:serviceaccounts:$APPLICATION_NAME-build -n $IMAGE_STREAM_NAMESPACE
    oc policy add-role-to-group system:image-puller system:serviceaccounts:$APPLICATION_NAME-stage -n $IMAGE_STREAM_NAMESPACE
    oc policy add-role-to-user system:image-puller system:serviceaccount:$APPLICATION_NAME-build:jenkins -n $IMAGE_STREAM_NAMESPACE
    oc policy add-role-to-user edit system:serviceaccount:$APPLICATION_NAME-build:jenkins -n $APPLICATION_NAME-stage
    oc project $APPLICATION_NAME-build
    oc create -n openshift -f https://raw.githubusercontent.com/openshift/origin/master/examples/jenkins/jenkins-persistent-template.json 2> /dev/null
    #NB!! for openshift v3.9 use    -p JENKINS_ENTANDO_IMAGE_VERSION
    oc new-app --template=jenkins-persistent \
        -p JENKINS_IMAGE_STREAM_TAG=jenkins:2\
        -p NAMESPACE=openshift \
        -p MEMORY_LIMIT=2048Mi \
        -p ENABLE_OAUTH=true
}

function patch_bitbucket_webhook_secret(){
  WEB_HOOK_SECRET_KEY=$(openssl rand -base64 29 | tr -d "=+/" | cut -c1-25)
  cat <<EOF | oc replace -n "${APPLICATION_NAME}-build" --force --grace-period 60 -f -
apiVersion: v1
kind: Secret
metadata:
  name: ${APPLICATION_NAME}-webhook-secret
  labels:
    application: "${APPLICATION_NAME}"
stringData:
  WebHookSecretKey: "$WEB_HOOK_SECRET_KEY"
EOF
  oc patch bc ${APPLICATION_NAME}-jenkins-pipeline -n "${APPLICATION_NAME}-build" --patch '{"spec":{"triggers":[{"type":"Bitbucket","bitbucket":{"secretReference":{"name":"${APPLICATION_NAME}-webhook-secret"}}}]}}'
  echo $WEB_HOOK_SECRET_KEY >> webhook.key

}

function create_prod_projects(){
    log_into_prod_cluster
    oc new-project $APPLICATION_NAME-prod
    oc policy add-role-to-group system:image-puller system:serviceaccounts:$APPLICATION_NAME-prod -n $IMAGE_STREAM_NAMESPACE
}

function create_projects(){
    echo "Creating projects for ${APPLICATION_NAME}"
    create_stage_projects
    create_prod_projects
}

function install_build_image_streams(){
  echo "Installing required images"
  #oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/entando-postgresql-jenkins-slave-openshift39.json -n $IMAGE_STREAM_NAMESPACE
  #oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/entando-maven-jenkins-slave-openshift39.json -n $IMAGE_STREAM_NAMESPACE
  #install_imagick_image
 }
#May be used in future once we have our Imagick Image in the right state
#function install_imagick_image(){
#  echo "Installing the Entando Imagick Image stream."
#  if [ -n "${REDHAT_REGISTRY_USERNAME}" ]; then
#    oc delete secret base-image-registry-secret -n "${APPLICATION_NAME}-build" 2>/dev/null
#    oc create secret docker-registry base-image-registry-secret \
#        --docker-server=registry.connect.redhat.com \
#        --docker-username=${REDHAT_REGISTRY_USERNAME} \
#        --docker-password=${REDHAT_REGISTRY_PASSWORD} \
#        --docker-email=${REDHAT_REGISTRY_USERNAME} \
#        -n "${APPLICATION_NAME}-build"
#    oc label secret base-image-registry-secret application=entando-central -n "${APPLICATION_NAME}-build"
#    oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/entando-eap71-clustered-openshift.json -n "${APPLICATION_NAME}-build"
#    oc delete secret base-image-registry-secret -n $IMAGE_STREAM_NAMESPACE 2>/dev/null
#    oc create secret docker-registry base-image-registry-secret \
#        --docker-server=registry.connect.redhat.com \
#        --docker-username=${REDHAT_REGISTRY_USERNAME} \
#        --docker-password=${REDHAT_REGISTRY_PASSWORD} \
#        --docker-email=${REDHAT_REGISTRY_USERNAME} \
#        -n $IMAGE_STREAM_NAMESPACE
#    oc label secret base-image-registry-secret application=entando-central -n $IMAGE_STREAM_NAMESPACE
#    oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/entando-eap71-clustered-openshift.json -n $IMAGE_STREAM_NAMESPACE
#  else
#    echo "Please set the REDHAT_REGISTRY_USERNAME and REDHAT_REGISTRY_PASSWORD variables so that the image can be retrieved from the secure Red Hat registry"
#    exit -1
#  fi
#}

function install_deployment_image_streams(){
  if  !  oc describe is/entando-postgresql95-openshift -n $IMAGE_STREAM_NAMESPACE| grep ${ENTANDO_IMAGE_VERSION} ; then
    oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/entando-postgresql95-openshift.json -n $IMAGE_STREAM_NAMESPACE
  fi
  if  !  oc describe is/entando-mysql57-openshift -n $IMAGE_STREAM_NAMESPACE| grep ${ENTANDO_IMAGE_VERSION} ; then
    oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/entando-mysql57-openshift.json -n $IMAGE_STREAM_NAMESPACE
  fi
  if  !  oc describe is/appbuilder -n $IMAGE_STREAM_NAMESPACE| grep ${ENTANDO_IMAGE_VERSION} ; then
    oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/appbuilder.json -n $IMAGE_STREAM_NAMESPACE
  fi
}

function recreate_source_secret(){
  echo "Creating the SCM source secret."
  read_config build
  if [ -n "${SCM_USERNAME}" ] && [ -n "${SCM_PASSWORD}" ]; then
    cat <<EOF | oc replace --force --grace-period 60 -f -
apiVersion: v1
kind: Secret
metadata:
  name: ${APPLICATION_NAME}-source-secret
  labels:
    application: "${APPLICATION_NAME}"
    credential.sync.jenkins.openshift.io: "true"
stringData:
  username: ${SCM_USERNAME}
  password: ${SCM_PASSWORD}
EOF
  fi
}

function recreate_prod_cluster_secret(){
    echo "Recreating the Production Cluster secret."
    read_config build
    if [ -n "${PRODUCTION_CLUSTER_USERNAME}" ] && [ -n "${PRODUCTION_CLUSTER_PASSWORD}" ] && [ -n "${PRODUCTION_CLUSTER_URL}" ]; then
      cat <<EOF | oc replace --force --grace-period 60 -f -
apiVersion: v1
kind: Secret
metadata:
  name: ${APPLICATION_NAME}-production-cluster-secret
  labels:
    application: "${APPLICATION_NAME}"
    credential.sync.jenkins.openshift.io: "true"
stringData:
  username: ${PRODUCTION_CLUSTER_USERNAME}
  password: ${PRODUCTION_CLUSTER_PASSWORD}
EOF
  fi
}

function recreate_external_docker_secret(){
  echo "Recreating the External Docker secret."
  read_config build
  if [ -n "${SHARED_DOCKER_REGISTRY_USERNAME}" ] && [ -n "${SHARED_DOCKER_REGISTRY_USERNAME}" ] && [ -n "${SHARED_DOCKER_REGISTRY_URL}" ]; then
    oc delete secret ${APPLICATION_NAME}-external-registry-secret 2>/dev/null
    oc create secret docker-registry ${APPLICATION_NAME}-external-registry-secret \
        --docker-server=${SHARED_DOCKER_REGISTRY_URL} \
        --docker-username=${SHARED_DOCKER_REGISTRY_USERNAME} \
        --docker-password=${SHARED_DOCKER_REGISTRY_PASSWORD} \
        --docker-email=${SHARED_DOCKER_REGISTRY_EMAIL}
    oc label secret ${APPLICATION_NAME}-external-registry-secret credential.sync.jenkins.openshift.io=true
    oc label secret ${APPLICATION_NAME}-external-registry-secret application=${APPLICATION_NAME}
    oc secrets link default ${APPLICATION_NAME}-external-registry-secret --for=pull
  fi

}

function prepare_pam_secret(){
    echo "Creating the RedHat PAM secret."
    if [ -n "${KIE_SERVER_USERNAME}" ] && [ -n "${KIE_SERVER_PASSWORD}" ] && [ -n "${KIE_SERVER_BASE_URL}" ] ; then
       cat <<EOF | oc replace --force --grace-period 60 -f -
apiVersion: v1
kind: Secret
metadata:
  name: entando-pam-secret
  labels:
    application: "${APPLICATION_NAME}"
stringData:
  username: ${KIE_SERVER_USERNAME}
  password: ${KIE_SERVER_PASSWORD}
  url: ${KIE_SERVER_BASE_URL}
EOF
    else
       cat <<EOF | oc replace --force --grace-period 60 -f -
apiVersion: v1
kind: Secret
metadata:
  name: entando-pam-secret
  labels:
    application: "${APPLICATION_NAME}"
stringData:
  username: dummy
  password: dummy
  url: dummy
EOF
    fi
}

function deploy_build_template(){
  echo "Deploying Build Templates IMAGE_STREAM_NAMESPACE=${IMAGE_STREAM_NAMESPACE}"
  if [ "$IMAGE_PROMOTION_ONLY" = "true" ]; then
    oc process -f $ENTANDO_OPS_HOME/Openshift/templates/reference-pipeline/entando-promote-only.yml \
            -p APPLICATION_NAME="${APPLICATION_NAME}" \
            -p IMAGE_STREAM_NAMESPACE="${IMAGE_STREAM_NAMESPACE}" \
            -p PRODUCTION_CLUSTER_URL="${PRODUCTION_CLUSTER_URL}" \
            -p PRODUCTION_CLUSTER_SECRET="${APPLICATION_NAME}-production-cluster-secret" \
            -p SHARED_DOCKER_REGISTRY_URL="${SHARED_DOCKER_REGISTRY_URL}" \
            -p SHARED_DOCKER_REGISTRY_SECRET="${APPLICATION_NAME}-external-registry-secret" \
            -p DOCKER_IMAGE_NAMESPACE="${DOCKER_IMAGE_NAMESPACE}" \
            -p PRODUCTION_CLUSTER_TOKEN="${PRODUCTION_CLUSTER_TOKEN}" \
            -p ENTANDO_IMAGE_VERSION="${ENTANDO_IMAGE_VERSION}" \
            -p DBMS="${DBMS}" \
          |  oc replace --force --grace-period 60  -f -
  else
    oc process -f $ENTANDO_OPS_HOME/Openshift/templates/reference-pipeline/entando-build-and-promote.yml \
            -p APPLICATION_NAME="${APPLICATION_NAME}" \
            -p IMAGE_STREAM_NAMESPACE="${IMAGE_STREAM_NAMESPACE}" \
            -p SOURCE_SECRET="${APPLICATION_NAME}-source-secret" \
            -p SOURCE_REPOSITORY_URL="${SOURCE_REPOSITORY_URL:-https://github.com/entando/entando-sample-full.git}" \
            -p SOURCE_REPOSITORY_REF="${SOURCE_REPOSITORY_REF:-v5.0.3-dev}" \
            -p PRODUCTION_CLUSTER_URL="${PRODUCTION_CLUSTER_URL}" \
            -p PRODUCTION_CLUSTER_SECRET="${APPLICATION_NAME}-production-cluster-secret" \
            -p SHARED_DOCKER_REGISTRY_URL="${SHARED_DOCKER_REGISTRY_URL}" \
            -p SHARED_DOCKER_REGISTRY_SECRET="${APPLICATION_NAME}-external-registry-secret" \
            -p DOCKER_IMAGE_NAMESPACE="${DOCKER_IMAGE_NAMESPACE}" \
            -p PRODUCTION_CLUSTER_TOKEN="${PRODUCTION_CLUSTER_TOKEN}" \
            -p ENTANDO_IMAGE_VERSION="${ENTANDO_IMAGE_VERSION}" \
            -p DBMS="${DBMS}" \
          |  oc replace --force --grace-period 60  -f -

  fi
}


function prepare_db_secret(){
  echo "Creating the Entando DB Secret for the $1 environment."
  if [ "${DEPLOY_DBMS}" = "true" ]; then
  # specifiy the service
      DB_SERVICE_HOST="${APPLICATION_NAME}-${DBMS}.${APPLICATION_NAME}-$1.svc"
      DB_SERVICE_PORT=$(determine_db_port ${DBMS})
  # generate passwords and save to passwords file
    if [ -f $CONFIG_DIR/$1-passwords.txt ]; then
      source $CONFIG_DIR/$1-passwords.txt
    else
      DB_PASSWORD=$(openssl rand -base64 24)
      DB_ADMIN_PASSWORD=$(openssl rand -base64 24)
      cat <<EOF > $CONFIG_DIR/$1-passwords.txt
DB_PASSWORD=${DB_PASSWORD}
DB_ADMIN_PASSWORD=${DB_ADMIN_PASSWORD}
EOF
    fi
  fi
  oc process -f $DB_SECRET_TEMPLATE \
            -p APPLICATION_NAME="${APPLICATION_NAME}" \
            -p SECRET_NAME="${APPLICATION_NAME}-db-file-secret-$1" \
            -p USERNAME="${DB_USERNAME}" \
            -p PASSWORD="${DB_PASSWORD}" \
            -p DB_HOSTNAME="${DB_SERVICE_HOST}" \
            -p DB_PORT="${DB_SERVICE_PORT}" \
            -p ADMIN_PASSWORD="${DB_ADMIN_PASSWORD}" \
            -p ADMIN_USERNAME="$(determine_db_admin $DBMS)" \
            -p DB_VENDOR="${DBMS}" \
          |  oc replace --force --grace-period 60  -f - || { echo "DB File Secret Creation Failed";exit 1; }
}
function deploy_runtime_templates(){
  oc process -f $ENTANDO_OPS_HOME/Openshift/templates/sample-jgroups-secret.yml \
            -p APPLICATION_NAME="${APPLICATION_NAME}" \
            -p SECRET_NAME="entando-app-secret" \
            | oc replace --force --grace-period 60  -f -
  if [ -n "$OIDC_AUTH_LOCATION" ] && [ -n "$OIDC_TOKEN_LOCATION" ] && [ -n "$OIDC_CLIENT_ID" ] && [ -n "$OIDC_REDIRECT_BASE_URL" ]; then
    oc process -f $ENTANDO_OPS_HOME/Openshift/templates/reference-pipeline/entando-eap71-deployment.yml \
            -p APPLICATION_NAME="${APPLICATION_NAME}" \
            -p ENVIRONMENT_TAG=$1 \
            -p IMAGE_STREAM_NAMESPACE="${IMAGE_STREAM_NAMESPACE}" \
            -p ENTANDO_DB_FILE_SECRET="${APPLICATION_NAME}-db-file-secret-$1" \
            -p ENTANDO_APP_BUILDER_HOSTNAME="${ENTANDO_APP_BUILDER_HOSTNAME}" \
            -p ENTANDO_ENGINE_SECURE_HOSTNAME="${ENTANDO_ENGINE_SECURE_HOSTNAME}" \
            -p ENTANDO_ENGINE_WEB_CONTEXT="${ENTANDO_ENGINE_WEB_CONTEXT}" \
            -p SHARED_DOCKER_REGISTRY_URL="${SHARED_DOCKER_REGISTRY_URL}" \
            -p DOCKER_IMAGE_NAMESPACE="${DOCKER_IMAGE_NAMESPACE}" \
            -p ENTANDO_OIDC_ACTIVE="true" \
            -p ENTANDO_OIDC_AUTH_LOCATION="$OIDC_AUTH_LOCATION" \
            -p ENTANDO_OIDC_TOKEN_LOCATION="$OIDC_TOKEN_LOCATION" \
            -p ENTANDO_OIDC_CLIENT_ID="$OIDC_CLIENT_ID" \
            -p ENTANDO_OIDC_REDIRECT_BASE_URL="$OIDC_REDIRECT_BASE_URL" \
            -p ENTANDO_IMAGE_VERSION="${ENTANDO_IMAGE_VERSION}" \
            | oc replace --force --grace-period 60  -f -
  else
    oc process -f $ENTANDO_OPS_HOME/Openshift/templates/reference-pipeline/entando-eap71-deployment.yml \
            -p APPLICATION_NAME="${APPLICATION_NAME}" \
            -p ENVIRONMENT_TAG=$1 \
            -p IMAGE_STREAM_NAMESPACE="${IMAGE_STREAM_NAMESPACE}" \
            -p ENTANDO_DB_FILE_SECRET="${APPLICATION_NAME}-db-file-secret-$1" \
            -p ENTANDO_APP_BUILDER_HOSTNAME="${ENTANDO_APP_BUILDER_HOSTNAME}" \
            -p ENTANDO_ENGINE_SECURE_HOSTNAME="${ENTANDO_ENGINE_SECURE_HOSTNAME}" \
            -p ENTANDO_ENGINE_WEB_CONTEXT="${ENTANDO_ENGINE_WEB_CONTEXT}" \
            -p SHARED_DOCKER_REGISTRY_URL="${SHARED_DOCKER_REGISTRY_URL}" \
            -p DOCKER_IMAGE_NAMESPACE="${DOCKER_IMAGE_NAMESPACE}" \
            -p ENTANDO_OIDC_ACTIVE="false" \
            -p ENTANDO_IMAGE_VERSION="${ENTANDO_IMAGE_VERSION}" \
            | oc replace --force --grace-period 60  -f -
  fi
  if [ "${DEPLOY_DBMS}" = "true" ]; then
    echo "Deploying DB Template $(determine_db_template $DBMS)"
    oc process -f "$ENTANDO_OPS_HOME/Openshift/templates/reference-pipeline/$(determine_db_template $DBMS)" \
            -p APPLICATION_NAME="${APPLICATION_NAME}" \
            -p IMAGE_STREAM_NAMESPACE="${IMAGE_STREAM_NAMESPACE}" \
            -p ENTANDO_IMAGE_VERSION="${ENTANDO_IMAGE_VERSION}" \
            -p ENTANDO_DB_FILE_SECRET="${APPLICATION_NAME}-db-file-secret-$1" \
            | oc replace --force --grace-period 60  -f -
  fi
}

function wait_for_stage_deployment(){
  COUNTER=0
  oc get pods -n ${APPLICATION_NAME}-build --selector name=jenkins
  until oc get pods -n ${APPLICATION_NAME}-build --selector name=jenkins | grep  '1/1\s*Running' ;
  do
    COUNTER=$(($COUNTER+1))
    if [ $COUNTER -gt 100 ]; then
      echo "Timeout waiting for Jenkins pod"
      exit -1
    fi
    echo "waiting for Jenkins:"
    sleep 10
  done
  until oc get pods -n ${APPLICATION_NAME}-stage --selector deploymentConfig=${APPLICATION_NAME}-postgresql | grep '1/1\s*Running' ;
  do
    COUNTER=$(($COUNTER+1))
    if [ $COUNTER -gt 100 ]; then
      echo "Timeout	waiting	for PostgreSQL pod"
      exit -1
    fi
    echo "waiting for PostgreSQL:"
    sleep 10
  done
}
function join_build_and_stage_network(){
    echo "Joining the build project and stage projects' network:"
    echo "running oc adm pod-network join-projects --to=${APPLICATION_NAME}-stage ${APPLICATION_NAME}-build"
    oc adm pod-network join-projects --to="${APPLICATION_NAME}-stage" "${APPLICATION_NAME}-build"
}
function populate_deployment_project(){
  echo "Populating the $1 project." 2> /dev/null
  oc project "${APPLICATION_NAME}-$1"
  read_config $1
  prepare_db_secret $1
  prepare_pam_secret $1
  deploy_runtime_templates $1
  recreate_external_docker_secret
}

function populate_build_project(){
  echo "Populating the build project." 2> /dev/null
  read_config build
  oc project "${APPLICATION_NAME}-build"
  recreate_source_secret
  install_build_image_streams
  deploy_build_template
  recreate_external_docker_secret
  recreate_prod_cluster_secret
  read_config stage
  prepare_db_secret stage
  read_config prod
  prepare_db_secret prod
}

function clear_stage_projects(){
    log_into_stage_cluster
    echo "Deleting all elements in STAGE with the label application=$APPLICATION_NAME"
    oc delete all -l application=$APPLICATION_NAME -n $APPLICATION_NAME-build
    oc delete all -l application=$APPLICATION_NAME -n $APPLICATION_NAME-stage
    oc delete secret -l application=$APPLICATION_NAME -n $APPLICATION_NAME-build
    oc delete secret -l application=$APPLICATION_NAME -n $APPLICATION_NAME-stage
    oc delete pvc -l application=$APPLICATION_NAME -n $APPLICATION_NAME-build
    oc delete pvc -l application=$APPLICATION_NAME -n $APPLICATION_NAME-stage
    oc delete bc --all -n $APPLICATION_NAME-build #because the Jenkins plugin would have recreated them by now :-)
}
function clear_prod_projects(){
    log_into_prod_cluster
    echo "Deleting all elements in PROD with the label application=$APPLICATION_NAME"
    oc delete all -l application=$APPLICATION_NAME -n  $APPLICATION_NAME-prod
    oc delete secret -l application=$APPLICATION_NAME -n  $APPLICATION_NAME-prod
    oc delete pvc -l application=$APPLICATION_NAME -n  $APPLICATION_NAME-prod
}

function clear_projects(){
    clear_stage_projects
    clear_prod_projects
}
function delete_prod_projects(){
    log_into_prod_cluster
    oc delete  project $APPLICATION_NAME-prod
}
function delete_stage_projects(){
    log_into_stage_cluster
    oc delete project $APPLICATION_NAME-build
    oc delete project $APPLICATION_NAME-stage
}
function delete_projects(){
    echo "Deleting projects for ${APPLICATION_NAME}"
    delete_stage_projects
    delete_prod_projects
}
function populate_prod_projects(){
    log_into_prod_cluster
    install_deployment_image_streams
    populate_deployment_project prod
}

function populate_stage_projects(){
    if [[ -z "${PRODUCTION_CLUSTER_TOKEN}" ]]; then
      log_into_prod_cluster
    fi
    log_into_stage_cluster
    install_deployment_image_streams
    populate_build_project
    populate_deployment_project stage
    join_build_and_stage_network
}

function populate_projects(){
    populate_prod_projects
    populate_stage_projects
}

COMMAND=$1
shift

for i in "$@"
do
case $i in
    -dbms=*|--database-management-system=*)
      DBMS="${i#*=}"
      shift # past argument=value
    ;;
    -an=*|--application-name=*)
      APPLICATION_NAME="${i#*=}"
      shift # past argument=value
    ;;
    -cfd=*|--config-dir=*)
      CONFIG_DIR="${i#*=}"
      shift # past argument=value
    ;;
    -isn=*|--image-stream-namespace=*)
      IMAGE_STREAM_NAMESPACE="${i#*=}"
      shift # past argument=value
    ;;
    -eiv=*|--entando-image-version=*)
      ENTANDO_IMAGE_VERSION="${i#*=}"
      shift # past argument=value
    ;;
    --image-promotion-only)
      IMAGE_PROMOTION_ONLY="true"
    ;;
    *)
    echo "Unknown option: $i"
    exit -1
esac
done
IMAGE_STREAM_NAMESPACE=${IMAGE_STREAM_NAMESPACE:-entando}
ENTANDO_IMAGE_VERSION=${ENTANDO_IMAGE_VERSION:-5.1.0}
DBMS=${DBMS:-postgresql}
CONFIG_DIR=${CONFIG_DIR:-${APPLICATION_NAME}-conf}
DB_SECRET_TEMPLATE=${DB_SECRET_TEMPLATE:-$ENTANDO_OPS_HOME/Openshift/templates/entando-db-file-secret.yml}
echo "IMAGE_STREAM_NAMESPACE=$IMAGE_STREAM_NAMESPACE"
case $COMMAND in
  create)
    create_projects
  ;;
  create-stage)
    create_stage_projects
  ;;
  create-prod)
    create_prod_projects
  ;;
  delete)
    delete_projects
  ;;
  delete-prod)
    delete_prod_projects
  ;;
  delete-stage)
    delete_stage_projects
  ;;
  populate-prod)
    populate_prod_projects
  ;;
  populate-stage)
    populate_stage_projects
  ;;
  populate)
    populate_projects
  ;;
  clear)
    clear_projects
  ;;
  clear-stage)
    clear_stage_projects
  ;;
  clear-prod)
    clear_prod_projects
  ;;
  recreate-external-docker-secret)
    recreate_external_docker_secret
  ;;
  recreate-prod-cluster-secret)
    recreate_prod_cluster_secret
  ;;
  recreate-source-secret)
    recreate_source_secret
  ;;
  log-into-prod)
    log_into_prod_cluster
  ;;
  log-into-stage)
    log_into_stage_cluster
  ;;
  patch-bitbucket-webhook-secret)
    patch_bitbucket_webhook_secret
  ;;
  *)
    echo "Unknown command: $COMMAND"
    exit -1
esac
