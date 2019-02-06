#!/usr/bin/env bash
docker pull entando/entando-eap71-quickstart-openshift:$1
docker pull entando/entando-postgresql95-openshift:$1
docker pull entando/entando-wildfly12-quickstart-openshift:$1
docker pull entando/entando-maven-jenkins-slave-openshift39:$1 
docker pull entando/entando-postgresql-jenkins-slave-openshift39:$1
