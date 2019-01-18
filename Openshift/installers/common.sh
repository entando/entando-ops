#!/usr/bin/env bash
function validate_environment(){
    if [ -z "${OPENSHIFT_DOMAIN_SUFFIX}" ]; then
        echo "OPENSHIFT_DOMAIN_SUFFIX not set. Please set it to the default name suffix that your Openshift cluster is setup to use"
        exit 1
    fi
}

function ensure_image_stream(){
    local IMAGE_STREAM=$1
    if  oc describe is/appbuilder -n ${IMAGE_STREAM_NAMESPACE}| grep ${ENTANDO_IMAGE_STREAM_TAG} &>/dev/null ; then
        echo "ImageStream $1 already has a tag ${ENTANDO_IMAGE_STREAM_TAG}"
    else
        echo "ImageStream $1 does not have the tag ${ENTANDO_IMAGE_STREAM_TAG}, recreating ImageStream ...."
        oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/${IMAGE_STREAM}.json -n ${IMAGE_STREAM_NAMESPACE}
    fi

}

function recreate_project(){
    oc delete project $1 --ignore-not-found
    while ! oc new-project $1 ; do
        echo "Waiting for $1 to be terminated"
        sleep 5
    done
    oc policy add-role-to-group system:image-puller system:serviceaccounts:$1 -n ${IMAGE_STREAM_NAMESPACE}
}

function test_deployment(){
    oc project ${APPLICATION_NAME}
    DEPLOYMENTS=$1
    APPBUILDER_SERVICES=$2
    ENTANDO_IMAGE_VERSION=$3
    echo "DEPLOYMENTS=$DEPLOYMENTS"
    echo "APPBUILDER_SERVICES=$APPBUILDER_SERVICES"
    echo "ENTANDO_IMAGE_VERSION=$ENTANDO_IMAGE_VERSION"
    for DEPLOYMENT in $(echo $DEPLOYMENTS | sed "s/,/ /g"); do
        timeout 600 $(dirname $BASH_SOURCE[0])/wait-for-deployment.sh $DEPLOYMENT || {  echo "Timed out waiting for deployment $DEPLOYMENT"; exit 1;  }
    done
    for APPBUILDER_SERVICE in $(echo $APPBUILDER_SERVICES | sed "s/,/ /g"); do
        oc delete pod ${APPLICATION_NAME}-test 2>/dev/null
        oc run  ${APPLICATION_NAME}-test --env ENTANDO_APPBUILDER_URL=http://${APPBUILDER_SERVICE}:5000  \
            -it --replicas=1  --restart=Never --image=docker-registry.default.svc:5000/entando/entando-smoke-tests:$ENTANDO_IMAGE_VERSION \
            --command --  mvn verify -Dtest=org.entando.selenium.smoketests.STAddTestUserTest -Dmaven.repo.local=/home/maven/.m2/repository \
            || {  echo "The 'AddUser' test failed"; exit 1;  }
    done
    for DEPLOYMENT in $(echo $DEPLOYMENTS | sed "s/,/ /g"); do
        echo "Downscaling deployment $DEPLOYMENT"
        oc scale --replicas=0 dc/$DEPLOYMENT
    done
    for DEPLOYMENT in $(echo $DEPLOYMENTS | sed "s/,/ /g"); do
        timeout 240 $(dirname $BASH_SOURCE[0])/wait-for-downscaling.sh $DEPLOYMENT || {  echo "Timed out waiting for downscaling of $DEPLOYMENT"; exit 1;  }
    done
    for DEPLOYMENT in $(echo $DEPLOYMENTS | sed "s/,/ /g"); do
        echo "Upscaling deployment $DEPLOYMENT"
        oc scale --replicas=1 dc/$DEPLOYMENT
    done
    for DEPLOYMENT in $(echo $DEPLOYMENTS | sed "s/,/ /g"); do
        timeout 360 $(dirname $BASH_SOURCE[0])/wait-for-deployment.sh $DEPLOYMENT || {  echo "Timed out waiting for upscaling of deployment $DEPLOYMENT"; exit 1;  }
    done
    for APPBUILDER_SERVICE in $(echo $APPBUILDER_SERVICES | sed "s/,/ /g"); do
        oc delete pod ${APPLICATION_NAME}-test 2>/dev/null
        oc run ${APPLICATION_NAME}-test --env ENTANDO_APPBUILDER_URL=http://${APPBUILDER_SERVICE}:5000  \
            -it --replicas=1  --restart=Never --image=docker-registry.default.svc:5000/entando/entando-smoke-tests:$ENTANDO_IMAGE_VERSION \
            --command -- mvn verify -Dtest=org.entando.selenium.smoketests.STLoginWithTestUserTest -Dmaven.repo.local=/home/maven/.m2/repository  \
            || {  echo "The 'Login' test failed"; exit 1;  }
    done
    oc delete pod ${APPLICATION_NAME}-test
}

export ENTANDO_OPS_HOME=$(dirname $(dirname $(dirname $(realpath $BASH_SOURCE[0]))))
echo $ENTANDO_OPS_HOME
# Read correct config file
for i in "$@"; do
    if [[ "$i" == "--config-file="* ]]; then
        CONFIG_FILE="${i#*=}"
        echo "Using CONFIG_FILE ${CONFIG_FILE})"
    fi
done
source $(dirname $BASH_SOURCE[0])/${CONFIG_FILE:-default}.conf || exit 1

# Override config file with argument values
for i in "$@" ;  do
    echo "i=$i"
    case $i in
        -an=*|--application-name=*)
            APPLICATION_NAME="${i#*=}"
        ;;
        -isn=*|--image-stream-namespace=*)
            IMAGE_STREAM_NAMESPACE="${i#*=}"
        ;;
        -eiv=*|--entando-image-version=*)
            ENTANDO_IMAGE_STREAM_TAG="${i#*=}"
        ;;
        -srr=*|--source-=repository-ref=*)
            SOURCE_REPOSITORY_REF="${i#*=}"
        ;;
        --openshift-domain-suffix)
            OPENSHIFT_DOMAIN_SUFFIX="${i#*=}"
        ;;
        *)
        ;;
    esac
done
