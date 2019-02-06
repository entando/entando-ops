#!/usr/bin/env bash
export VERSION=${1:-5.0.3-SNAPSHOT}
./build-all.sh $VERSION || { echo "Build failed"; exit 1; }
./test-all.sh $VERSION || { echo "Test failed"; exit 1; }
./push-all.sh $VERSION || { echo "Push failed"; exit 1; }
