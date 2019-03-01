#!/usr/bin/env bash
#NB!!! This file is copied from common/s2i in the Docker build hook. Only modify the original file!
source $(dirname ${BASH_SOURCE[0]})/build-jetty-command.sh "$@"
$JETTY_COMMAND