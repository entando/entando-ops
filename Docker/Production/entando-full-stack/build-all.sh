#!/usr/bin/env bash
pushd appbuilder
./build.sh $1
popd
pushd microengine
./build.sh $1
popd
pushd entando
./build.sh $1
popd
pushd postgresql
./build.sh $1
popd
