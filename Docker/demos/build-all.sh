#!/usr/bin/env bash
pushd fsi-cc-dispute-customer
./build.sh $1
popd
pushd fsi-cc-dispute-admin
./build.sh $1
popd
