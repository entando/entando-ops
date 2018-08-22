# This image provides a very lightweight base for building and running Entando 
# EAP based applications with an embedded Derby db.
# It builds using maven and runs the resulting artifacts on EAP 

FROM registry.access.redhat.com/jboss-eap-7/eap71-openshift:1.3
LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Platform for building and running Entando quickstart applications on EAP 7.1" \
      io.k8s.display-name="Entando on EAP 7.1"
ARG ENTANDO_VERSION_TO_BUILD
ENV ENTANDO_VERSION="$ENTANDO_VERSION_TO_BUILD" \
    STI_SCRIPTS_PATH="/usr/local/s2i"
COPY ./contrib/wfmodules /opt/eap/modules
COPY ./contrib/wildfly-configuration/standalone-openshift.xml /opt/eap/standalone/configuration/standalone-openshift.xml
COPY ./s2i/bin ${STI_SCRIPTS_PATH}
COPY ./settings.xml $HOME/.m2/settings.xml
USER root
RUN chown -Rf 185:0 $HOME/.m2/settings.xml && chmod -Rf ug+rw $HOME/.m2/settings.xml && \
    mkdir -p /entando-data/databases  && chown -Rf 185:0 /entando-data/ && chmod -Rf ug+rwx /entando-data/ && \
    mkdir -p /entando-database-templates  && chown -Rf 185:0 /entando-database-templates/ && chmod -Rf ug+rwx /entando-database-templates/ && \
    source /opt/rh/rh-maven35/enable && \
    mvn dependency:get -s $HOME/.m2/settings.xml -Dartifact=org.entando:entando-derby-template:$ENTANDO_VERSION \
        -Dpackaging=tar.gz -DrepoUrl=https://repository.entando.org/repository/maven-snapshots/ \
        -Ddest=/entando-database-templates/entando-derby-template.tar.gz && \
    rm -Rf $HOME/.m2/repository && \
    cd /entando-database-templates/ && tar xvf entando-derby-template.tar.gz && rm entando-derby-template.tar.gz && \
    chown -Rf 185:0 /entando-database-templates/ && chmod -Rf ug+rw /entando-database-templates/ && \
    chown -Rf 185:0 ${STI_SCRIPTS_PATH}  && chmod -Rf ug+rwx ${STI_SCRIPTS_PATH} && \
    chown 185:0 /opt/eap/standalone/configuration/standalone-openshift.xml && chmod ug+rw /opt/eap/standalone/configuration/standalone-openshift.xml && \
    chown -Rf 185:0 /opt/eap/modules/org/apache/derby && chmod -Rf ug+rw /opt/eap/modules/org/apache/derby
USER 185
ENV DB_SERVICE_PREFIX_MAPPING="portdb-derby=PORTDB,servdb-derby=SERVDB" \
    PORTDB_NONXA="true" \
    PORTDB_JTA="false" \
    PORTDB_URL="jdbc:derby:/entando-data/databases/entandoPort" \
    PORTDB_JNDI="java:jboss/datasources/entandoPortDataSource" \
    PORTDB_DRIVER="derby" \
    PORTDB_USERNAME="agile" \
    PORTDB_PASSWORD="agile" \
    PORTDB_SERVICE_HOST="dummy" \
    PORTDB_SERVICE_PORT="1527" \
    SERVDB_NONXA="true" \
    SERVDB_JTA="false" \
    SERVDB_URL="jdbc:derby:/entando-data/databases/entandoServ" \
    SERVDB_JNDI="java:jboss/datasources/entandoServDataSource" \
    SERVDB_DRIVER="derby" \
    SERVDB_USERNAME="agile" \
    SERVDB_PASSWORD="agile" \
    SERVDB_SERVICE_HOST="dummy" \
    SERVDB_SERVICE_PORT="1527"
CMD "${STI_SCRIPTS_PATH}/run"
#NB!!! Place the VOLUME declaration AFTER the state (permissions, ownership, content) of the volume has been set
VOLUME /entando-data
