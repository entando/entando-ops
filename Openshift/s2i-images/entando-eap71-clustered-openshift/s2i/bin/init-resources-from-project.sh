#!/usr/bin/env bash
#remove all previous Entando data from parent images
rm -Rf /entando-data-templates/* > /dev/null 2>&1
if [ -d src/main/webapp/resources ]; then
mkdir -p /entando-data-templates/resources > /dev/null 2>&1
if ! cp -rf src/main/webapp/resources/* /entando-data-templates/resources/ ; then
  exit 1
fi
fi
if [ -d src/main/webapp/protected ]; then
mkdir -p /entando-data-templates/protected > /dev/null 2>&1
if ! cp -rf src/main/webapp/protected/* /entando-data-templates/protected/ ; then
  exit 1
fi
fi
echo $(date +%s | sha256sum | base64 | head -c 32) > /entando-data-templates/build_id
chmod -Rf ug+rw /entando-data-templates/
chown -Rf $USERID_TO_USE:0 /entando-data-templates/
exit 0
