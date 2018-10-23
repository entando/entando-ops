WEB_HOOK_SECRET_KEY=$(openssl rand -base64 12)
  cat <<EOF | oc replace -n "${APPLICATION_NAME}-build" --force --grace-period 60 -f -
apiVersion: v1
kind: Secret
metadata:
  name: ${APPLICATION_NAME}-webhook-secret
  labels:
    application: "${APPLICATION_NAME}"
stringData:
  WebHookSecretKey: "$WEB_HOOK_SECRET_KEY"
EOF
oc patch bc ${APPLICATION_NAME}-jenkins-pipeline --patch '{"spec":{"triggers":[{"type":"Bitbucket","bitbucket":{"secretReference":{"name":"${APPLICATION_NAME}-webhook-secret"}}}]}}'
echo $WEB_HOOK_SECRET_KEY
