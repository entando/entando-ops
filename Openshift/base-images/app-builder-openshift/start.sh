#!/bin/bash

# Install and build entando app
#npm run build
pushd build/static/js
#escape slashes
ESCAPED_DOMAIN=$(echo $DOMAIN | sed -E "s/\//\\\\\//g")
sed -i -E "s/$DOMAIN_MARKER/$ESCAPED_DOMAIN/g" $(ls main.*.js)
#Execute serve
popd
serve build