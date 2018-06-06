oc process -f ../templates/entando-eap-71-with-postgresql-95.yml \
  -p SOURCE_REPOSITORY_URL=https://github.com/ampie/entando-sample.git \
  -p PAM_SECRET=our-pam-secret \
  -p DB_SECRET=our-db-secret
  #| oc create -f -
