# This image provides a very lightweight base for building and running Entando
# Wildfly based applications with an embedded Derby db.
# It builds using maven and runs the resulting artifacts on Wildfly

#FROM openshift/wildfly-120-centos7:latest
FROM entando/entando-wildfly12-quickstart-openshift:5.0.1-SNAPSHOT
LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Platform for building and running Entando quickstart applications on WildFly 12.0.0.Final" \
      io.k8s.display-name="Entando on WildFly 12.0.0.Final"

ENV ENTANDO_VERSION="5.0.1-SNAPSHOT"

#stay in root to ensure chmod works
USER root
COPY ./contrib/maven-setup /tmp/maven-setup
RUN chmod -Rf ug+rw /tmp/maven-setup && chown -Rf 1001:root /tmp/maven-setup

#Run all of this as 1001 as this will be the user under which the S2I build takes place
USER 1001
RUN cd /tmp/maven-setup && ./prepare_m2_repo.sh $ENTANDO_VERSION

# Add wildfly customizations  e.g. two datasources
#USER root
#COPY ./contrib/wfmodules/ /wildfly/modules
#COPY ./contrib/wildfly-configuration/standalone.xml /wildfly/standalone/configuration/standalone.xml
COPY ./s2i/bin/ /usr/libexec/s2i/
USER root
RUN chown -Rf 1001:0 /usr/libexec/s2i/ && chmod -Rf ug+rwx /usr/libexec/s2i/
USER 1001
#RUN mkdir -p /entando-data/databases  && chown -Rf 1001:0 /entando-data/ && chmod -Rf ug+rwx /entando-data/ && \
#    mkdir -p /entando-database-templates  && chown -Rf 1001:0 /entando-database-templates/ && chmod -Rf ug+rwx /entando-database-templates/ && \
#    mvn dependency:get -Dartifact=org.entando:entando-derby-template:$ENTANDO_VERSION \
#        -Dpackaging=tar.gz -DrepoUrl=https://repository.entando.org/repository/maven-snapshots/ \
#        -Ddest=/entando-database-templates/entando-derby-template.tar.gz && \
#    cd /entando-database-templates/ && tar xvf entando-derby-template.tar.gz && rm entando-derby-template.tar.gz && \
#    chown -Rf 1001:0 /usr/libexec/s2i/ && chmod -Rf ug+rwx /usr/libexec/s2i/ && \
#    chown 1001:0 /wildfly/bin/standalone.conf && chmod ug+rw /wildfly/bin/standalone.conf && \
#    chown 1001:0 /wildfly/standalone/configuration/standalone.xml && chmod ug+rw /wildfly/standalone/configuration/standalone.xml && \
#    chown -Rf 1001:0 /wildfly/modules/org/apache/derby && chmod -Rf ug+rw /wildfly/modules/org/apache/derby && \
#    chown -Rf 1001:0 /entando-database-templates && chmod -Rf ug+rw /entando-database-templates
#USER 1001
ENV DB_SERVICE_PREFIX_MAPPING="portdb-derby=PORTDB,servdb-derby=SERVDB" \
    PORTDB_NONXA="true" \
    PORTDB_JRA="false" \
    PORTDB_URL="jdbc:derby:/entando-data/databases/entandoPort" \
    PORTDB_JNDI="java:jboss/datasources/entandoPortDataSource" \
    PORTDB_DRIVER="derby" \
    PORTDB_USERNAME="agile" \
    PORTDB_PASSWORD="agile" \
    PORTDB_SERVICE_HOST="dummy" \
    PORTDB_SERVICE_PORT="1527" \
    SERVDB_NONXA="true" \
    SERVDB_JRA="false" \
    SERVDB_URL="jdbc:derby:/entando-data/databases/entandoServ" \
    SERVDB_JNDI="java:jboss/datasources/entandoServDataSource" \
    SERVDB_DRIVER="derby" \
    SERVDB_USERNAME="agile" \
    SERVDB_PASSWORD="agile" \
    SERVDB_SERVICE_HOST="dummy" \
    SERVDB_SERVICE_PORT="1527"