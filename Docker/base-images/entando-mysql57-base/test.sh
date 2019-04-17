#!/usr/bin/env bash
docker rm $(docker stop mysql-test) || true

set -xeo pipefail
docker run --name mysql-test  -d -e ENV_FILES=/etc/mysql-test-datasources/datasources.env  entando/entando-mysql57-base:$1
sleep 5
docker exec mysql-test /usr/libexec/s2i/test/run || { echo "MySQL Image test failed"; exit -1; }
docker rm $(docker stop mysql-test) || true


