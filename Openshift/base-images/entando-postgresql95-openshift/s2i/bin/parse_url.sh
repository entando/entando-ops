# Extract the protocol (includes trailing "://").
KIE_SERVER_PROTOCOL="$(echo $KIE_SERVER_URL | sed -nr 's,^(.*)://.*,\1,p')"

# Extract the user (includes trailing "@").
KIE_SERVER_USER="$(echo $KIE_SERVER_URL | sed -nr 's,^(.*@).*,\1,p')"

# Extract the port (includes leading ":").
KIE_SERVER_PORT="$(echo $KIE_SERVER_URL | sed -nr 's,(.*:)([0-9]+)(.*),\2,p')"

# Extract the path (includes leading "/" or ":").
KIE_SERVER_PATH="$(echo $KIE_SERVER_URL| sed -nr 's,(^.*://)([^/]*)(/)(.*),\4,p')"

# Remove the path from the URL.
KIE_SERVER_HOST="$(echo $KIE_SERVER_URL| sed -nr 's,(^.*://)([^/\:]*)([:/].*),\2,p')"

echo "proto: $KIE_SERVER_PROTOCOL"
echo "host: $KIE_SERVER_HOST"
echo "port: $KIE_SERVER_PORT"
echo "path: $KIE_SERVER_PATH"