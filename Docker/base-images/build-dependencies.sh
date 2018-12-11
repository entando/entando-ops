#!/usr/bin/env bash
pushd entando-dependencies-base
./build.sh $1
popd
pushd entando-dependencies-full
./build.sh $1
popd
