# This image provides a base for building and running Entando WildFly based applications.
# It builds using maven and runs the resulting artifacts on WildFly 12.0.0 Final
# Note to self: we couldn't use entando-wildfly12-quickstart-openshift because of permissions on Volumes TODO see if it is fixable

FROM openshift/wildfly-120-centos7:latest
LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Platform for building and running Entando quickstart applications on WildFly 12.0.0.Final" \
      io.k8s.display-name="Entando on WildFly 12.0.0.Final"
USER root
ENV ENTANDO_VERSION="5.0.1"
COPY ./contrib/wildfly-modules/ /wildfly/modules
COPY ./contrib/wildfly-configuration/standalone.xml /wildfly/standalone/configuration/standalone.xml
VOLUME /entando-data
RUN mkdir /entando-data/databases && \
    curl https://raw.githubusercontent.com/ampie/entando-database-templates/master/derby-${ENTANDO_VERSION}-template.tar.gz -o /entando-data/databases/data-template.tar.gz && \
    cd /entando-data/databases/  && tar xvf data-template.tar.gz && rm data-template.tar.gz && \
    chown 1001:0 /usr/libexec/s2i/run && chmod ug+rwx /usr/libexec/s2i/run && \
    mkdir /entando-data/resources /entando-data/indexdir && \
    chown 1001:0 /wildfly/standalone/configuration/standalone.xml && chmod ug+rw /wildfly/standalone/configuration/standalone.xml && \
    chown -Rf 1001:0 /entando-data  && chmod -Rf ug+rw /entando-data && \
    chown -Rf 1001:0 /wildfly/modules/org/apache/derby && chmod -Rf ug+rw /wildfly/modules/org/apache/derby
ENTRYPOINT /usr/libexec/s2i/run
USER 1001
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

