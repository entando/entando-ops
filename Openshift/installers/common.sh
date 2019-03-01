#!/usr/bin/env bash
function validate_environment(){
    if [ -z "${OPENSHIFT_DOMAIN_SUFFIX}" ]; then
        echo "OPENSHIFT_DOMAIN_SUFFIX not set. Please set it to the default name suffix that your Openshift cluster is setup to use"
        exit 1
    fi
}

function ensure_image_stream(){
    local IMAGE_STREAM=$1
    if  oc describe is/appbuilder -n ${IMAGE_STREAM_NAMESPACE}| grep ${ENTANDO_IMAGE_VERSION} &>/dev/null ; then
        echo "ImageStream $1 already has a tag ${ENTANDO_IMAGE_VERSION}"
    else
        echo "ImageStream $1 does not have the tag ${ENTANDO_IMAGE_VERSION}, recreating ImageStream ...."
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
function get_deployment_for_route(){
    echo $(oc get service $(oc get route $1 -o go-template='{{.spec.to.name}}') -o go-template='{{.spec.selector.deploymentConfig}}')
}
function get_url_for_route(){
    PATH_SEGMENT="$(oc get route $1 -o go-template='{{.spec.path}}')"
    if [ "$PATH_SEGMENT" = "<no value>" ] ;then
      PATH_SEGMENT=""
    fi
    if [  "$(oc get route $1 -o go-template='{{.spec.tls}}')" = "<no value>" ]; then
        echo "http://$(oc get route $1 -o go-template='{{.spec.host}}')${PATH_SEGMENT}"
    else
        echo "https://$(oc get route $1 -o go-template='{{.spec.host}}')${PATH_SEGMENT}"
    fi
}

function test_deployment(){
    for i in "$@" ;  do
        case $i in
            --database-deployments=*)
                DATABASE_DEPLOYMENT_ARRAY=$(echo "${i#*=}" | sed "s/,/ /g")
                echo "Database Deployments: ${DATABASE_DEPLOYMENT_ARRAY[*]}"
            ;;
            --appbuilder-routes=*)
                APPBUILDER_ROUTE_ARRAY=$(echo "${i#*=}" | sed "s/,/ /g")
                echo "AppBuilder Routes: ${APPBUILDER_ROUTE_ARRAY[*]}"
            ;;
            --engine-routes=*)
                ENGINE_ROUTE_ARRAY=$(echo "${i#*=}" | sed "s/,/ /g")
                echo "Engine Routes: ${ENGINE_ROUTE_ARRAY[*]}"
            ;;
            *)
            ;;
        esac
    done
    oc project ${APPLICATION_NAME}
    REGISTRY_IP=$(oc get pod $(oc get pods -n default|grep -o "docker-registry[-0-9a-z]*") -n default -o go-template={{.status.podIP}})
    #REGISTRY_IP=docker-registry.default.svc
    #Wait for Engines to come up
    for ENGINE_ROUTE in ${ENGINE_ROUTE_ARRAY[@]}; do
        DEPLOYMENT=$(get_deployment_for_route $ENGINE_ROUTE)
        timeout 600 $(dirname $BASH_SOURCE[0])/wait-for-deployment.sh $DEPLOYMENT || {  echo "Timed out waiting for deployment $DEPLOYMENT"; exit 1;  }
    done
    # Run AddTestUser test
    for APPBUILDER_ROUTE in ${APPBUILDER_ROUTE_ARRAY[@]}; do
        oc delete pod ${APPLICATION_NAME}-test 2>/dev/null
        sleep 1
        echo "Running 'AddTestUser' test on AppBuilder at $(get_url_for_route ${APPBUILDER_ROUTE})"
        oc run  ${APPLICATION_NAME}-test --env ENTANDO_APPBUILDER_URL="$(get_url_for_route ${APPBUILDER_ROUTE})"  \
            -it --replicas=1  --restart=Never --image=${REGISTRY_IP}:5000/entando/entando-smoke-tests:$ENTANDO_IMAGE_VERSION \
            --command -- mvn verify -Dtest=org.entando.selenium.smoketests.STAddTestUserTest -Dmaven.repo.local=/home/maven/.m2/repository \
            || {  echo "The 'AddTestUser' test failed"; exit 1;  }
    done
    #Downscale Entando Engines
    for ENGINE_ROUTE in ${ENGINE_ROUTE_ARRAY[@]}; do
        DEPLOYMENT=$(get_deployment_for_route $ENGINE_ROUTE)
        echo "Downscaling deployment $DEPLOYMENT"
        oc scale --replicas=0 dc/$DEPLOYMENT
    done
    for ENGINE_ROUTE in ${ENGINE_ROUTE_ARRAY[@]}; do
        DEPLOYMENT=$(get_deployment_for_route $ENGINE_ROUTE)
        timeout 240 $(dirname $BASH_SOURCE[0])/wait-for-downscaling.sh $DEPLOYMENT || {  echo "Timed out waiting for downscaling of $DEPLOYMENT"; exit 1;  }
    done
    #Downscale Databases
    for DEPLOYMENT in ${DATABASE_DEPLOYMENT_ARRAY[@]}; do
        echo "Downscaling deployment $DEPLOYMENT"
        oc scale --replicas=0 dc/$DEPLOYMENT
    done
    for DEPLOYMENT in ${DATABASE_DEPLOYMENT_ARRAY[@]}; do
        timeout 240 $(dirname $BASH_SOURCE[0])/wait-for-downscaling.sh $DEPLOYMENT || {  echo "Timed out waiting for downscaling of $DEPLOYMENT"; exit 1;  }
    done
    #Upscale Databases
    for DEPLOYMENT in ${DATABASE_DEPLOYMENT_ARRAY[@]}; do
        echo "Upscaling deployment $DEPLOYMENT"
        oc scale --replicas=1 dc/$DEPLOYMENT
    done
    for DEPLOYMENT in ${DATABASE_DEPLOYMENT_ARRAY[@]}; do
        DEPLOYMENT=$(get_deployment_for_route $ENGINE_ROUTE)
        timeout 360 $(dirname $BASH_SOURCE[0])/wait-for-deployment.sh $DEPLOYMENT || {  echo "Timed out waiting for upscaling of deployment $DEPLOYMENT"; exit 1;  }
    done
    #Upscale Entando Engines
    for ENGINE_ROUTE in ${ENGINE_ROUTE_ARRAY[@]}; do
        DEPLOYMENT=$(get_deployment_for_route $ENGINE_ROUTE)
        echo "Upscaling deployment $DEPLOYMENT"
        oc scale --replicas=1 dc/$DEPLOYMENT
    done
    for ENGINE_ROUTE in ${ENGINE_ROUTE_ARRAY[@]}; do
        DEPLOYMENT=$(get_deployment_for_route $ENGINE_ROUTE)
        timeout 360 $(dirname $BASH_SOURCE[0])/wait-for-deployment.sh $DEPLOYMENT || {  echo "Timed out waiting for upscaling of deployment $DEPLOYMENT"; exit 1;  }
    done
    #Run LoginWitTestUser tests
    for i in "${!ENGINE_ROUTE_ARRAY[@]}"; do
        APPBUILDER_ROUTE=${APPBUILDER_ROUTE_ARRAY[$i]}
        ENGINE_ROUTE=${ENGINE_ROUTE_ARRAY[$i]}
        oc delete pod ${APPLICATION_NAME}-test 2>/dev/null
        sleep 1
        echo "Running 'LoginWithTestUser' test on AppBuilder at $(get_url_for_route ${APPBUILDER_ROUTE}) and Engine at $(get_url_for_route ${ENGINE_ROUTE})"
        oc run ${APPLICATION_NAME}-test --env ENTANDO_APPBUILDER_URL="$(get_url_for_route ${APPBUILDER_ROUTE})"  \
            --env ENTANDO_ENGINE_URL="$(get_url_for_route ${ENGINE_ROUTE})" \
            -it --replicas=1  --restart=Never --image=${REGISTRY_IP}:5000/entando/entando-smoke-tests:$ENTANDO_IMAGE_VERSION \
            --command -- mvn verify -Dtest=org.entando.selenium.smoketests.STLoginWithTestUserTest -Dmaven.repo.local=/home/maven/.m2/repository  \
            || {  echo "The 'LoginWithTestUser' test failed"; exit 1;  }
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
#    echo "i=$i"
    case $i in
        -an=*|--application-name=*)
            APPLICATION_NAME="${i#*=}"
        ;;
        -isn=*|--image-stream-namespace=*)
            IMAGE_STREAM_NAMESPACE="${i#*=}"
        ;;
        -eiv=*|--entando-image-version=*)
            ENTANDO_IMAGE_VERSION="${i#*=}"
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
