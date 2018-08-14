#!/usr/bin/env bash
export VERSION=${1:-5.0.1-SNAPSHOT}
echo $VERSION
source hooks/build
