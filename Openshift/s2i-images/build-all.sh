#!/usr/bin/env bash
pushd entando-eap71-quickstart-openshift
./build.sh $1
popd
pushd entando-postgresql95-openshift
./build.sh $1
popd
pushd entando-wildfly12-quickstart-openshift
./build.sh $1
popd
