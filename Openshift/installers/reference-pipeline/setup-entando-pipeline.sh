#!/usr/bin/env bash
source $(dirname $0)/../common.sh
function create_projects(){
    echo "Creating projects for ${APPLICATION_NAME}"
    oc new-project $APPLICATION_NAME
    oc new-project $APPLICATION_NAME-build
    oc new-project $APPLICATION_NAME-stage
    oc new-project $APPLICATION_NAME-prod
    oc policy add-role-to-group system:image-puller system:serviceaccounts:$APPLICATION_NAME-build -n $IMAGE_STREAM_NAMESPACE
    oc policy add-role-to-group system:image-builder system:serviceaccounts:$APPLICATION_NAME-build -n $APPLICATION_NAME
    oc policy add-role-to-user edit system:serviceaccount:$APPLICATION_NAME-build:jenkins -n $APPLICATION_NAME-stage
    oc policy add-role-to-user edit system:serviceaccount:$APPLICATION_NAME-build:jenkins -n $APPLICATION_NAME-prod
    oc policy add-role-to-user edit system:serviceaccount:$APPLICATION_NAME-build:jenkins -n $APPLICATION_NAME
    oc policy add-role-to-group system:image-puller system:serviceaccounts:$APPLICATION_NAME-stage -n $IMAGE_STREAM_NAMESPACE
    oc policy add-role-to-group system:image-puller system:serviceaccounts:$APPLICATION_NAME-stage -n $APPLICATION_NAME
    oc policy add-role-to-group system:image-puller system:serviceaccounts:$APPLICATION_NAME-prod -n $IMAGE_STREAM_NAMESPACE
    oc policy add-role-to-group system:image-puller system:serviceaccounts:$APPLICATION_NAME-prod -n $APPLICATION_NAME
    oc project $APPLICATION_NAME-build
    oc new-app --template=jenkins-persistent \
        -p JENKINS_IMAGE_STREAM_TAG=jenkins:2\
        -p NAMESPACE=openshift \
        -p MEMORY_LIMIT=2048Mi \
        -p ENABLE_OAUTH=true

}
function populate_build_project(){
  echo "Populating the build project." 2> /dev/null
  oc project $APPLICATION_NAME-build
    #NEXUS_URL=$(calculate_mirror_url)
    echo "PROD secret: ${PROD_DB_SECRET}"
    echo "STAGE secret: ${STAGE_DB_SECRET}"
  oc process -f $ENTANDO_OPS_HOME/Openshift/templates/reference-pipeline/entando-build.yml \
            -p APPLICATION_NAME="${APPLICATION_NAME}" \
            -p ENTANDO_IMAGE_STREAM_NAMESPACE="entando" \
            -p ENTANDO_IMAGE_TAG="5.0.1-SNAPSHOT" \
            -p SOURCE_SECRET="${APPLICATION_NAME}-source-secret" \
            -p SOURCE_REPOSITORY_URL=${SOURCE_REPOSITORY_URL:-https://github.com/ampie/entando-sample.git} \
            -p SOURCE_REPOSITORY_REF=${SOURCE_REPOSITORY_REF:-master} \
            -p ENTANDO_DB_SECRET_STAGE="${STAGE_DB_SECRET}" \
          |  oc replace --force --grace-period 60  -f -
#            -p PROD_DB_SECRET="${PROD_DB_SECRET}" \
}
function populate_image_project(){
  echo "Populating the image project." 2> /dev/null
  oc project $APPLICATION_NAME
  oc process -f $ENTANDO_OPS_HOME/Openshift/templates/reference-pipeline/entando-output-image-streams.yml \
            -p APPLICATION_NAME="${APPLICATION_NAME}" \
            | oc replace --force --grace-period 60  -f -
}
function populate_deployment_project(){
  echo "Populating the $1 project." 2> /dev/null
  oc project $APPLICATION_NAME-$1
  oc process -f $ENTANDO_OPS_HOME/Openshift/templates/reference-pipeline/entando-eap71-deployment.yml \
            -p APPLICATION_NAME="${APPLICATION_NAME}" \
            -p ENVIRONMENT_TAG=$1 \
            -p ENTANDO_BASEURL="$1.${APPLICATION_NAME}.$(get_openshift_subdomain)" \
            -p ENTANDO_DB_SECRET="${APPLICATION_NAME}-db-secret-$1" \
            -p IMAGE_STREAM_NAMESPACE="${APPLICATION_NAME}" \
            | oc replace --force --grace-period 60  -f -
  oc process -f $ENTANDO_OPS_HOME/Openshift/templates/reference-pipeline/entando-postgresql95-deployment.yml \
            -p APPLICATION_NAME="${APPLICATION_NAME}" \
            -p ENTANDO_IMAGE_STREAM_NAMESPACE="entando" \
            -p ENTANDO_IMAGE_TAG="5.0.1-SNAPSHOT" \
            -p ENTANDO_DB_SECRET="${APPLICATION_NAME}-db-secret-$1" \
            | oc replace --force --grace-period 60  -f -
}

function populate_projects(){
    populate_build_project
    populate_image_project
    populate_deployment_project stage
    populate_deployment_project prod
}
function clear_projects(){
    echo "Deleting all elements with the label application=$APPLICATION_NAME"
    oc delete all -l application=$APPLICATION_NAME -n $APPLICATION_NAME
    oc delete all -l application=$APPLICATION_NAME -n $APPLICATION_NAME-build
    oc delete all -l application=$APPLICATION_NAME -n $APPLICATION_NAME-stage
    oc delete all -l application=$APPLICATION_NAME -n  $APPLICATION_NAME-prod
}


function delete_projects(){
    echo "Deleting projects for ${APPLICATION_NAME}"
    oc delete project $APPLICATION_NAME
    oc delete project $APPLICATION_NAME-build
    oc delete project $APPLICATION_NAME-stage
    oc delete  project $APPLICATION_NAME-prod
}

if [[ $1 =~ -.* ]]; then
  echo "The first argument should be one of create/delete"
  exit -1
else
  COMMAND=$1
  shift
fi
for i in "$@"
do
case $i in
    -an=*|--application-name=*)
      APPLICATION_NAME="${i#*=}"
      shift # past argument=value
    ;;
    -sru=*|--source-repository-url=*)
      SOURCE_REPOSITORY_URL="${i#*=}"
      shift # past argument=value
    ;;
    -srr=*|--source-repository-ref=*)
      SOURCE_REPOSITORY_REF="${i#*=}"
      shift # past argument=value
    ;;
    -isn=*|--image-stream-namespace=*)
      IMAGE_STREAM_NAMESPACE="${i#*=}"
      shift # past argument=value
    ;;
    -sds=*|--stage-db-secret=*)
      STAGE_DB_SECRET="${i#*=}"
      shift # past argument=value
    ;;
    -pds=*|--prod-db-secret=*)
      PROD_DB_SECRET="${i#*=}"
      shift # past argument=value
    ;;
    *)
    echo "Unknown option: $i"
    exit -1
esac
done
IMAGE_STREAM_NAMESPACE=${IMAGE_STREAM_NAMESPACE:-openshift}
case $COMMAND in
  create)
    create_projects
  ;;
  delete)
    delete_projects
  ;;
  populate)
    populate_projects
  ;;
  clear)
    clear_projects
  ;;
  *)
    echo "Unknown command: $COMMAND"
    exit -1
esac
