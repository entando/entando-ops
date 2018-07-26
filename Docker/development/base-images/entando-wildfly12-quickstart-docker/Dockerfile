# This image provides a base for building and running Entando WildFly based applications.
# It builds using maven and runs the resulting artifacts on WildFly 12.0.0 Final

FROM openshift/wildfly-120-centos7:latest
LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Platform for building and running Entando quickstart applications on WildFly 12.0.0.Final" \
      io.k8s.display-name="Entando on WildFly 12.0.0.Final"
USER root
COPY ./contrib/wildfly-modules/ /wildfly/modules
COPY ./contrib/wildfly-configuration/standalone.xml /wildfly/standalone/configuration/standalone.xml
COPY ./contrib/entando-database-templates  /entando-data/databases
RUN chown 1001:0 /usr/libexec/s2i/run && chmod ug+rwx /usr/libexec/s2i/run && \
    mkdir /entando-data/resources /entando-data/indexdir && \
    chown 1001:0 /wildfly/standalone/configuration/standalone.xml && chmod ug+rw /wildfly/standalone/configuration/standalone.xml && \
    chown -Rf 1001:0 /entando-data  && chmod -Rf ug+rw /entando-data && \
    chown -Rf 1001:0 /wildfly/modules/org/apache/derby && chmod -Rf ug+rw /wildfly/modules/org/apache/derby
VOLUME /entando-data
ENTRYPOINT /usr/libexec/s2i/run
USER 1001
