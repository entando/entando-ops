# Extract the protocol (includes trailing "://").
PAM_PROTOCOL="$(echo $PAM_URL | sed -nr 's,^(.*)://.*,\1,p')"

# Extract the user (includes trailing "@").
PAM_USER="$(echo $PAM_URL | sed -nr 's,^(.*@).*,\1,p')"

# Extract the port (includes leading ":").
PAM_PORT="$(echo $PAM_URL | sed -nr 's,(.*:)([0-9]+)(.*),\2,p')"

# Extract the path (includes leading "/" or ":").
PAM_PATH="$(echo $PAM_URL| sed -nr 's,(^.*://)([^/]*)(/)(.*),\4,p')"

# Remove the path from the URL.
PAM_HOST="$(echo $PAM_URL| sed -nr 's,(^.*://)([^/\:]*)([:/].*),\2,p')"

echo "proto: $PAM_PROTOCOL"
echo "host: $PAM_HOST"
echo "port: $PAM_PORT"
echo "path: $PAM_PATH"