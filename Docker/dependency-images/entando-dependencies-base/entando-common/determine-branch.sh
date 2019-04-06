#!/usr/bin/env bash
#NB!!! This file is copied from common/s2i in the Docker build hook. Only modify the original file!
#Returns the appropriate branch in Entando's maven projects
ENTANDO_MASTER_BRANCH_VERSION="5.2.0-SNAPSHOT"
BRANCH=${ENTANDO_VERSION%-*}
case "$ENTANDO_VERSION" in
    $ENTANDO_MASTER_BRANCH_VERSION )
        echo "master"
    ;;
    *-SNAPSHOT)
        echo "v${BRANCH}-dev"
    ;;
    *)
        echo "v${BRANCH}"
    ;;
esac
