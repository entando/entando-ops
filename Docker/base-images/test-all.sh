#!/usr/bin/env bash
echo "The JEE Base images have no direct tests yet"
pushd entando-mysql57-base
./test.sh $1 || { echo "Mysql test failed"; exit 1; }
popd
pushd entando-postgresql95-base
./test.sh $1 || { echo "Postgresql test failed"; exit 1; }
popd