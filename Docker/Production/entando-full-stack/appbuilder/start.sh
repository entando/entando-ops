#!/bin/bash

# Install and build entando app
#npm run build
pushd static/js
#escape slashes
ESCAPED_DOMAIN=$(echo $DOMAIN | sed -E "s/\//\\\\\//g")
sed -i -E "s/$DOMAIN_MARKER/$ESCAPED_DOMAIN/g" $(ls main.*.js)
if [ $USE_MOCKS=="true" ]; then
     sed -i -E "s/USE_MOCKS\\:\\!1/USE_MOCKS\\:\\!0/g" $(ls main.*.js)
fi
#Execute serve
popd
serve