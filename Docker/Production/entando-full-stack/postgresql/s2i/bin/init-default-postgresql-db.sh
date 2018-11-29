#!/usr/bin/env bash
mkdir /tmp/db-init
cd /tmp/db-init
curl -L "https://github.com/entando/entando-sample-full/archive/v${ENTANDO_VERSION}.zip" -o entando-sample-full.zip
unzip entando-sample-full.zip
cd entando-sample-full-${ENTANDO_VERSION}
${STI_SCRIPTS_PATH}/init-postgresql-db.sh
if [ $? -eq 0 ]; then
    cd /tmp
    rm -Rf db-init
    rm -Rf $HOME/.m2/repository
    exit 0
else
    exit 1
fi
