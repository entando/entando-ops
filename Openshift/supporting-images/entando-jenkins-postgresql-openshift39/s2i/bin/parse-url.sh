
# Extract the protocol (includes trailing "://").
export URL_PROTOCOL="$(echo $1 | sed -nr 's,^(.*)://.*,\1,p')"

# Extract the port (includes leading ":").
export URL_PORT="$(echo $1 | sed -nr 's,(.*:)([0-9]+)(.*),\2,p')"

# Extract the path (includes leading "/" or ":").
export URL_PATH="$(echo $1| sed -nr 's,(^.*://)([^/]*)(/)(.*),\4,p')"

# Remove the path from the URL.
export URL_HOST="$(echo $1| sed -nr 's,(^.*://)([^/\:]*)([:/].*),\2,p')"

echo "proto: $URL_PROTOCOL"
echo "host: $URL_HOST"
echo "port: $URL_PORT"
echo "path: $URL_PATH"
