#!/usr/bin/env bash
docker rm $(docker stop postgresql-test) || true

set -xeo pipefail
docker run --name postgresql-test -d -e ENV_FILES=/etc/postgresql-test-datasources/datasources.env  entando/entando-postgresql95-base:$1
sleep 5
docker exec postgresql-test /usr/libexec/s2i/test/run || { echo "PostreSQL Image test failed"; exit -1; }
docker rm $(docker stop postgresql-test) || true


