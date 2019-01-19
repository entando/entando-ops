#!/usr/bin/env bash
export ENTANDO_IMAGE_VERSION=${1:-5.0.3-SNAPSHOT}

function cleanup(){
    docker-compose -f docker-compose-qa.yml down &>/dev/null
    docker-compose -f docker-compose-postgresql-qa.yml down &>/dev/null
    docker volume rm entando-full-stack_entando-volume &>/dev/null
    docker volume rm entando-full-stack_entando-pg-volume &>/dev/null
    docker network rm entando-full-stack_entando-network &>/dev/null
}
if [ -n "$OPENSHIFT_REGISTRY" ]; then
    INSTALLER_DIR=$(realpath $(dirname $(realpath ${BASH_SOURCE[0]}))/../../../Openshift/installers)
    export TEST_DEPLOYMENT=true
    export DESTROY_DEPLOYMENT=true
    ${INSTALLER_DIR}/install-entando-full-stack.sh || { echo "Entando Full Stack Openshift test failed"; exit 1; }
fi

cleanup
docker-compose -f docker-compose-qa.yml up -d || { echo "Could not bring down docker containers"; exit 1; }
timeout 180 ./wait-for-engine.sh || { echo "Timed out waiting for Engine"; exit 1; }

docker run --rm --network=entando-full-stack_entando-network -e ENTANDO_APPBUILDER_URL=http://appbuilder:5000  \
    entando/entando-smoke-tests:$ENTANDO_IMAGE_VERSION mvn verify -Dtest=org.entando.selenium.smoketests.STAddTestUserTest \
    || {  echo "The 'AddUser' test failed"; exit 1;  }

docker-compose -f docker-compose-qa.yml down || { echo "Could not bring down docker containers"; exit 1; }
docker-compose -f docker-compose-qa.yml up -d || { echo "Could not spin up docker containers"; exit 1; }
timeout 180 ./wait-for-engine.sh || { echo "Timed out waiting for Engine"; exit 1; }

docker run --rm --network=entando-full-stack_entando-network -e ENTANDO_APPBUILDER_URL=http://appbuilder:5000 \
    entando/entando-smoke-tests:$ENTANDO_IMAGE_VERSION mvn verify -Dtest=org.entando.selenium.smoketests.STLoginWithTestUserTest \
    || {  echo "The 'Login' test failed"; exit 1;  }

cleanup


docker-compose -f docker-compose-postgresql-qa.yml up -d
timeout 180 ./wait-for-engine.sh || { echo "Timed out waiting for Engine"; exit 1; }

docker run --rm --network=entando-full-stack_entando-network -e ENTANDO_APPBUILDER_URL=http://appbuilder:5000  \
    entando/entando-smoke-tests:$ENTANDO_IMAGE_VERSION mvn verify -Dtest=org.entando.selenium.smoketests.STAddTestUserTest \
    || {  echo "The 'AddUser' test failed"; exit 1;  }

docker-compose -f docker-compose-postgresql-qa.yml down || { echo "Could not bring down docker containers"; exit 1; }
docker volume rm entando-full-stack_entando-volume || { echo "Could not remove the standard Entando volume"; exit 1; }
docker-compose -f docker-compose-postgresql-qa.yml up -d || { echo "Could not spin up docker containers"; exit 1; }
timeout 180 ./wait-for-engine.sh || { echo "Timed out waiting for Engine"; exit 1; }

docker run --rm --network=entando-full-stack_entando-network -e ENTANDO_APPBUILDER_URL=http://appbuilder:5000 \
    entando/entando-smoke-tests:$ENTANDO_IMAGE_VERSION mvn verify -Dtest=org.entando.selenium.smoketests.STLoginWithTestUserTest \
    || {  echo "The 'Login' test failed"; exit 1;  }
cleanup

echo "Entando Full Stack tests successful"
exit 0
