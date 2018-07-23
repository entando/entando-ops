# This image provides a base for building and running Entando WildFly based applications.
# It builds using maven and runs the resulting artifacts on WildFly 12.0.0 Final

FROM openshift/wildfly-120-centos7:latest
LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Platform for building and running Entando quickstart applications on WildFly 12.0.0.Final" \
      io.k8s.display-name="Entando on WildFly 12.0.0.Final"

ENV ENTANDO_VERSION="5.0.1"


#stay in root to ensure chmod works
USER root
COPY ./contrib/maven-setup /tmp/maven-setup
RUN chmod -Rf ug+rw /tmp/maven-setup && chown -Rf 1001:root /tmp/maven-setup

#Run all of this as 1001 as this will be the user under which the S2I build takes place
USER 1001
WORKDIR /tmp/maven-setup/
RUN ./prepare_m2_repo.sh $ENTANDO_VERSION asdf
COPY ./contrib/maven-setup/settings-entando.xml $HOME/.m2/settings.xml
WORKDIR $HOME

# Add wildfly customizations  e.g. two datasources
USER root
RUN chown 1001:0 $HOME/.m2/settings.xml && chmod ug+rw $HOME/.m2/settings.xml
#COPY ./contrib/wfbin/standalone.conf /wildfly/bin/standalone.conf
COPY ./contrib/wfmodules/ /wildfly/modules
COPY ./contrib/wfdata/entando /wildfly/standalone/entando-data-template
COPY ./contrib/wildfly-configuration/standalone.xml /wildfly/standalone/configuration/standalone.xml
COPY ./s2i/bin/run /usr/libexec/s2i/run
RUN chown 1001:0 /usr/libexec/s2i/run && chmod ug+rwx /usr/libexec/s2i/run && \
    chown 1001:0 /wildfly/bin/standalone.conf && chmod ug+rw /wildfly/bin/standalone.conf && \
    chown 1001:0 /wildfly/standalone/configuration/standalone.xml && chmod ug+rw /wildfly/standalone/configuration/standalone.xml && \
    chown -Rf 1001:0 /wildfly/standalone/entando-data-template  && chmod -Rf ug+rw /wildfly/standalone/entando-data-template && \
    chown -Rf 1001:0 /wildfly/modules/org/apache/derby && chmod -Rf ug+rw /wildfly/modules/org/apache/derby

USER 1001
