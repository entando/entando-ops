#!/usr/bin/env bash
pushd entando-dependencies-base
./build.sh $1
popd
pushd entando-dependencies-full
./build.sh $1
popd
pushd entando-eap71-base
./build.sh $1
popd
pushd entando-postgresql95-base
./build.sh $1
popd
pushd entando-wildfly12-base
./build.sh $1
popd
