#!/usr/bin/env bash
source $(dirname $0)/common.sh
#source $(dirname $0)/install-nexus.sh
echo "This script installs the Entando Sample project on Entando, EAP 7.1  and PostgreSQL 9.5"
#potential parameters:
export APPLICATION_NAME=entando-sample

export HOSTNAME_HTTP="entando-core.$(get_openshift_subdomain)"
export HOSTNAME_HTTPS="secure-entando-core.$(get_openshift_subdomain)"

function recreate_entando_app_secret(){
  echo_header "Creating Entando keystore secret."
  oc delete secret entando-app-secret 2> /dev/null
  oc delete sa entando-service-account 2> /dev/null
  export JGROUPS_ENCRYPT_PASSWORD=$(openssl rand -base64 20)
  export JGROUPS_CLUSTER_PASSWORD=$(openssl rand -base64 20)
  export HTTPS_PASSWORD=$(openssl rand -base64 20)
  rm jgroups.jceks 2> /dev/null
  keytool -genseckey -alias jgroups -storetype JCEKS -keystore jgroups.jceks -keypass $JGROUPS_ENCRYPT_PASSWORD -storepass $JGROUPS_ENCRYPT_PASSWORD
  rm  keystore.jks 2> /dev/null
  rm  $HOSTNAME_HTTPS.p12 2> /dev/null
  if [ -f /etc/letsencrypt/live/$HOSTNAME_HTTPS/fullchain.pem ]; then
    sudo openssl pkcs12 -export -in  /etc/letsencrypt/live/$HOSTNAME_HTTPS/fullchain.pem \
      -inkey /etc/letsencrypt/live/$HOSTNAME_HTTPS/privkey.pem > $HOSTNAME_HTTPS.p12 \
      -password pass:$HTTPS_PASSWORD
    sudo chmod ug+rw $HOSTNAME_HTTPS.p12
    keytool -importkeystore -srckeystore $HOSTNAME_HTTPS.p12 -srcstoretype pkcs12 -srcstorepass $HTTPS_PASSWORD \
      -destkeystore keystore.jks -destkeypass $HTTPS_PASSWORD -deststorepass $HTTPS_PASSWORD
  else
    echo "No LetsEncrypt certificates found - generating a self signed certificate"
    keytool -genkey -keyalg RSA -alias jboss -keystore keystore.jks -storepass $HTTPS_PASSWORD -keypass $HTTPS_PASSWORD \
        -validity 360 -keysize 2048 -dname "cn=Joe Bloggs, ou=Entando, o=Entando, c=IT"
  fi
  oc create secret generic entando-app-secret --from-file=keystore.jks --from-file=jgroups.jceks
  oc create serviceaccount entando-service-account
  sleep 0.5  # TODO not very scientific
  oc secrets link --for=mount entando-service-account entando-app-secret
}

function recreate_postgresql_secret(){
    echo_header "Creating Postgresql secret."
    export DATABASE_PASSWORD=$(openssl rand -base64 20)
    cat <<EOF | oc replace --force --grace-period 60 -f -
apiVersion: v1
kind: Secret
metadata:
  name: "${APPLICATION_NAME}-db-secret"
stringData:
  jdbcUrl: "jdbc:postgresql://$APPLICATION_NAME-postgresql.$(oc project -q).svc:5432/"
  username: "agile"
  password: "$DATABASE_PASSWORD"
EOF

}

function recreate_kie_secret(){
    #Just a place holder for when we may want to instantiate PAM here. We'll probably generate passwords then too
    echo_header "Creating KIEServer secret."
    cat <<EOF | oc replace --force --grace-period 60 -f -
apiVersion: v1
kind: Secret
metadata:
  name: "${APPLICATION_NAME}-kieserver-secret"
stringData:
  url: "http://${APPLICATION_NAME}-kieserver.${OPENSHIFT_PROJECT}.svc:8080"
  username: "pamAdmin"
  password: "redhatpam1!"
EOF

}


function dump_passwords(){
    echo_header "Dumping generated passwords to passwords.txt"
    rm passwords.txt 2> /dev/null
    cat <<EOT >>passwords.txt
JGROUPS_ENCRYPT_PASSWORD=$JGROUPS_ENCRYPT_PASSWORD
JGROUPS_CLUSTER_PASSWORD=$JGROUPS_CLUSTER_PASSWORD
HTTPS_PASSWORD=$HTTPS_PASSWORD
DATABASE_PASSWORD=$DATABASE_PASSWORD
EOT

}
function recreate_source_secret(){
    #Just a place holder for when we may want to instantiate PAM here. We'll probably generate passwords then too
    echo_header "Creating the BitBucket source secret."
    cat <<EOF | oc replace --force --grace-period 60 -f -
apiVersion: v1
kind: Secret
metadata:
  name: "${APPLICATION_NAME}-source-secret"
stringData:
  username: "username"
  password: "password"
type: "kubernetes.io/basic-auth"
EOF

}

function recreate_secrets_and_linked_service_accounts() {
    recreate_entando_app_secret
    recreate_postgresql_secret
    recreate_kie_secret
    recreate_source_secret
    dump_passwords
}

function recreate_entando_application(){
    echo_header "Recreating Entando 5 Application config." 2> /dev/null
    #NEXUS_URL=$(calculate_mirror_url)
    ENTANDO_BASEURL="http://$HOSTNAME_HTTP/entando"
    oc process -f $ENTANDO_OPS_HOME/Openshift/templates/entando-eap71-with-postgresql95.yml \
            -p APPLICATION_NAME="${APPLICATION_NAME}" \
            -p KIE_SERVER_SECRET="${APPLICATION_NAME}-kieserver-secret" \
            -p DB_SECRET="${APPLICATION_NAME}-db-secret" \
            -p SOURCE_SECRET="${APPLICATION_NAME}-source-secret" \
            -p ENTANDO_PORT_DATABASE="entandoPortDb" \
            -p ENTANDO_SERV_DATABASE="entandoServDb" \
            -p HTTPS_SECRET="entando-app-secret" \
            -p HTTPS_PASSWORD="$HTTPS_PASSWORD" \
            -p ENTANDO_BASEURL=$ENTANDO_BASEURL \
            -p JGROUPS_ENCRYPT_SECRET="entando-app-secret" \
            -p JGROUPS_ENCRYPT_PASSWORD="$JGROUPS_ENCRYPT_PASSWORD" \
            -p JGROUPS_CLUSTER_PASSWORD="$JGROUPS_CLUSTER_PASSWORD" \
            -p JGROUPS_ENCRYPT_NAME="jgroups" \
            -p IMAGE_STREAM_NAMESPACE="$(oc project -q)" \
            -p HOSTNAME_HTTPS=$HOSTNAME_HTTPS \
            -p HOSTNAME_HTTP=$HOSTNAME_HTTP \
            |  oc replace --force --grace-period 60  -f -
#            -p MAVEN_MIRROR_URL="$NEXUS_URL" \
}
oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/appbuilder.json
oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/entando-eap71-quickstart-openshift.json
oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/entando-postgresql95-openshift.json

recreate_secrets_and_linked_service_accounts
recreate_entando_application
