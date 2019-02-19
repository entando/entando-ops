#!/bin/bash

# Install and build entando app
#npm run build
pushd static/js
#escape slashes
ESCAPED_DOMAIN=$(echo $DOMAIN | sed -E "s/\//\\\\\//g")
sed -i -E "s/$DOMAIN_MARKER/$ESCAPED_DOMAIN/g" $(ls main.*.js)
ESCAPED_CLIENT_SECRET=$(echo $CLIENT_SECRET | sed -E "s/\//\\\\\//g")
sed -i -E "s/$CLIENT_SECRET_MARKER/$ESCAPED_CLIENT_SECRET/g" $(ls main.*.js)
#Execute serve
popd
serve