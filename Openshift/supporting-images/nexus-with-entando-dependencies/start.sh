#!/usr/bin/env bash
if ! [ "$(ls -A /nexus-data/etc)" ]; then
  echo "New Nexus instance detected. Copying Entando Dependencies"
  cp /nexus-data-template/* /nexus-data/ -rf
fi
bin/nexus run

