docker.withRegistry('http://${EXTERNAL_DOCKER_REGISTRY_URL}', '${APPLICATION_NAME}-build-${APPLICATION_NAME}-external-registry-credential') {
    docker.image(
            '${EXTERNAL_DOCKER_REGISTRY_URL}/${EXTERNAL_DOCKER_PROJECT}/${APPLICATION_NAME}:dev'
    ).push(
            '${EXTERNAL_DOCKER_REGISTRY_URL}/${EXTERNAL_DOCKER_PROJECT}/${APPLICATION_NAME}:dev-${BUILD_NUMBER}'
    )
    docker.image(
            '${EXTERNAL_DOCKER_REGISTRY_URL}/${EXTERNAL_DOCKER_PROJECT}/${APPLICATION_NAME}:dev'
    ).push(
            '${EXTERNAL_DOCKER_REGISTRY_URL}/${EXTERNAL_DOCKER_PROJECT}/${APPLICATION_NAME}:stage'
    )
}
openshift.selector("is/${APPLICATION_NAME}").delete()
openshift.create(
        """
                                          kind: ImageStream
                                          apiVersion: v1
                                          metadata:
                                            name: ${APPLICATION_NAME}
                                            labels:
                                              application: "${APPLICATION_NAME}"
                                          spec:
                                            tags:
                                            - from:
                                                kind: DockerImage
                                                name: "${EXTERNAL_DOCKER_REGISTRY_URL}/${EXTERNAL_DOCKER_PROJECT}/${
            APPLICATION_NAME
        }:dev-${env.BUILD_NUMBER}"
                                              name: "${ENVIRONMENT_TAG}"
                                        """
)
pipeline {
    agent none
    stages {
        stage('Bring down ${APPLICATION_NAME} Prod Deployment') {
            agent {
                label "entando-maven"
            }
            steps {
                script {
                    openshift.withCluster('insecure://${PRODUCTION_CLUSTER_URL}', '${PRODUCTION_CLUSTER_TOKEN}') {
                        openshift.withProject('${APPLICATION_NAME}-prod') {
                            def deploymentConfig = openshift.selector('dc/${APPLICATION_NAME}-engine')
                            deploymentConfig.scale('--replicas=0')
                        }
                    }
                }
            }
        }
        stage('Prepare ${APPLICATION_NAME} Production Database') {
            agent {
                label 'entando-postgresql'
            }
            steps {
                withCredentials([[$class          : 'UsernamePasswordMultiBinding', credentialsId: '${APPLICATION_NAME}-build-${PRODUCTION_CLUSTER_SECRET}',
                                  usernameVariable: 'CLUSTER_USERNAME', passwordVariable: 'CLUSTER_PASSWORD']]) {
                    sh '''
                                  #!/bin/bash
                                  oc login -u $CLUSTER_USERNAME -p $CLUSTER_PASSWORD https://openshift.serv.run:8443 --insecure-skip-tls-verify
                                  PG_POD=$(oc get pods -n ${APPLICATION_NAME}-prod -l deploymentConfig=${APPLICATION_NAME}-postgresql | grep '${APPLICATION_NAME}-[a-zA-Z0-9\\-]*' -o)
                                  nohup oc port-forward $PG_POD 5432:5432  -n ${APPLICATION_NAME}-prod  >  forwarding.log 2>&1&
                                  for i in {1..60}
                                  do
                                      sleep 5
                                      cat forwarding.log
                                      if fgrep --quiet "Forwarding from" forwarding.log
                                      then
                                          exit 0
                                      fi
                                  done
                                  exit -1
                              '''
                }
                git url: '${SOURCE_REPOSITORY_URL}', branch: '${SOURCE_REPOSITORY_REF}', credentialsId: '${APPLICATION_NAME}-build-${SOURCE_SECRET}'
                withCredentials([[$class          : 'UsernamePasswordMultiBinding', credentialsId: '${APPLICATION_NAME}-build-${APPLICATION_NAME}-db-file-secret-prod',
                                  usernameVariable: 'DB_USERNAME', passwordVariable: 'DB_PASSWORD']]) {
                    sh '''
                                  #!/bin/bash
                                  #Hack to populate all the ENV Variables
                                  source ${HOME}/export-db-variables.sh "${DB_PASSWORD}"
                                  if [ -n "${CONTEXT_DIR}" ]; then
                                     cd "${CONTEXT_DIR}"
                                  fi
                                  set -e
                                  export PORTDB_SERVICE_HOST=localhost
                                  export SERVDB_SERVICE_HOST=localhost
                                  export PORTDB_SERVICE_PORT=5432
                                  export SERVDB_SERVICE_PORT=5432
                                  export PORTDB_URL="jdbc:postgresql://${PORTDB_SERVICE_HOST}:${PORTDB_SERVICE_PORT}/${PORTDB_DATABASE}"
                                  export SERVDB_URL="jdbc:postgresql://${SERVDB_SERVICE_HOST}:${SERVDB_SERVICE_PORT}/${SERVDB_DATABASE}"
                                  ${HOME}/backup-dbs.sh
                                  ${HOME}/recreate-dbs.sh
                                  ${HOME}/init-postgresql-db.sh
                              '''
                }
            }

            post {
                failure {
                    withCredentials([[$class          : 'UsernamePasswordMultiBinding', credentialsId: '${APPLICATION_NAME}-build-${APPLICATION_NAME}-db-file-secret-prod',
                                      usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
                        sh '''
                                      #!/bin/bash
                                      #Hack to populate all the ENV Variables
                                      source ${HOME}/export-db-variables.sh "${PASSWORD}"
                                      if [ -n "${CONTEXT_DIR}" ]; then
                                         cd "${CONTEXT_DIR}"
                                      fi
                                      export PORTDB_SERVICE_HOST=localhost
                                      export SERVDB_SERVICE_HOST=localhost
                                      export PORTDB_SERVICE_PORT=5432
                                      export SERVDB_SERVICE_PORT=5432
                                      export PORTDB_URL="jdbc:postgresql://${PORTDB_SERVICE_HOST}:${PORTDB_SERVICE_PORT}/${PORTDB_DATABASE}"
                                      export SERVDB_URL="jdbc:postgresql://${SERVDB_SERVICE_HOST}:${SERVDB_SERVICE_PORT}/${SERVDB_DATABASE}"
                                      ${HOME}/restore-dbs.sh
                                  '''
                    }
                }
            }
        }
        stage("Push ${APPLICATION_NAME}:prod image") {
            agent {
                label "entando-maven"
            }
            steps {
                script {
                    openshift.withCluster() {
                        openshift.withProject("${APPLICATION_NAME}-build") {
                            openshift.selector("bc", "${APPLICATION_NAME}-tag-as-prod").startBuild("--wait")
                        }
                    }
                }
            }
        }
        stage("Start up ${APPLICATION_NAME} Deployment") {
            agent {
                label "entando-maven"
            }
            steps {
                script {
                    openshift.withCluster('${PRODUCTION_CLUSTER_URL}', '${APPLICATION_NAME}-build-${APPLICATION_NAME}-production-cluster-secret') {
                        openshift.withProject("${APPLICATION_NAME}-prod") {
                            def deploymentConfig = openshift.selector("dc/${APPLICATION_NAME}-engine")
                            def rolloutManager = deploymentConfig.rollout()
                            rolloutManager.latest()
                            deploymentConfig.scale("--replicas=2")
                        }
                    }
                }
            }
        }
    }
}