# This image provides a base for building and running Entando WildFly based applications.
# It builds using maven and runs the resulting artifacts on WildFly 12.0.0 Final
# Note to self: we couldn't use entando-wildfly12-quickstart-openshift because of permissions on Volumes TODO see if it is fixable

FROM openshift/wildfly-120-centos7:latest
LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Platform for building and running Entando quickstart applications on WildFly 12.0.0.Final" \
      io.k8s.display-name="Entando on WildFly 12.0.0.Final"
ARG ENTANDO_VERSION_TO_BUILD
ENV ENTANDO_VERSION="$ENTANDO_VERSION_TO_BUILD"
COPY ./contrib/wfmodules /wildfly/modules
COPY ./contrib/wildfly-configuration/standalone.xml /wildfly/standalone/configuration/standalone.xml
COPY ./s2i/bin ${STI_SCRIPTS_PATH}
COPY ./settings.xml $HOME/.m2/settings.xml
USER root
RUN chown -Rf 1001:0 $HOME/.m2/settings.xml && chmod -Rf ug+rw $HOME/.m2/settings.xml && \
    mkdir -p /entando-data/databases  && chown -Rf 1001:0 /entando-data/ && chmod -Rf ug+rwx /entando-data/ && \
    mkdir -p /entando-database-templates  && chown -Rf 1001:0 /entando-database-templates/ && chmod -Rf ug+rwx /entando-database-templates/ && \
    mvn dependency:get -s $HOME/.m2/settings.xml -Dartifact=org.entando:entando-derby-template:$ENTANDO_VERSION \
        -Dpackaging=tar.gz -DrepoUrl=https://repository.entando.org/repository/maven-snapshots/ \
        -Ddest=/entando-database-templates/entando-derby-template.tar.gz && \
    rm -Rf $HOME/.m2/repository && \
    cd /entando-database-templates/ && tar xvf entando-derby-template.tar.gz && rm entando-derby-template.tar.gz && \
    chown -Rf 1001:0 /entando-database-templates/ && chmod -Rf ug+rw /entando-database-templates/ && \
    chown -Rf 1001:0 ${STI_SCRIPTS_PATH} && chmod -Rf ug+rwx ${STI_SCRIPTS_PATH} && \
    chown 1001:0 /wildfly/bin/standalone.conf && chmod ug+rw /wildfly/bin/standalone.conf && \
    chown 1001:0 /wildfly/standalone/configuration/standalone.xml && chmod ug+rw /wildfly/standalone/configuration/standalone.xml && \
    chown -Rf 1001:0 /wildfly/modules/org/apache/derby && chmod -Rf ug+rw /wildfly/modules/org/apache/derby
USER 1001
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
