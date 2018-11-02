#!/usr/bin/env bash
pushd entando-maven-jenkins-slave-openshift39
./build.sh $1
popd
pushd entando-postgresql-jenkins-slave-openshift39
./build.sh $1
popd
