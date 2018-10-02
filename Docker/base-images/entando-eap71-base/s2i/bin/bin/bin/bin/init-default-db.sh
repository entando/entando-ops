#!/usr/bin/env bash
mkdir /tmp/db-init
cd /tmp/db-init
mvn archetype:generate -B --settings $HOME/.m2/settings.xml \
        -Dfilter=entando \
        -DarchetypeGroupId=org.entando.entando \
        -DarchetypeArtifactId=entando-archetype-web-app-BPM \
        -DarchetypeVersion="${ENTANDO_VERSION}" \
        -DgroupId=org.entando \
        -DartifactId=entando \
        -Dversion=1.0 \
        -Dpackage=org.entando
cd entando
$(dirname ${BASH_SOURCE[0]})/init-db.sh
cd /tmp
rm -Rf db-init
rm -Rf $HOME/.m2/repository