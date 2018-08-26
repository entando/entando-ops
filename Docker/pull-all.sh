#!/usr/bin/env bash
docker pull entando/entando-eap71-base:$1
docker pull entando/entando-postgresql95-base:$1
docker pull entando/entando-wildfly12-base:$1
docker pull entando/postgresql:$1 
docker pull entando/appbuilder:$1
docker pull entando/microengine:$1
docker pull entando/engine-api:$1

