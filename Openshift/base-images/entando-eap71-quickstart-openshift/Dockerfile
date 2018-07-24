# This image provides a very lightweight base for building and running Entando 
# EAP based applications with an embedded Derby db.
# It builds using maven and runs the resulting artifacts on EAP 

FROM registry.access.redhat.com/jboss-eap-7/eap71-openshift:1.3
LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Platform for building and running Entando quickstart applications on EAP 7.1" \
      io.k8s.display-name="Entando on EAP 7.1"

ENV ENTANDO_VERSION="5.0.1"


#stay in root to ensure chmod works
USER root
COPY ./contrib/maven-setup /tmp/maven-setup
RUN chmod -Rf ug+rw /tmp/maven-setup && chown -Rf 185:root /tmp/maven-setup

#Run all of this as 185 as this will be the user under which the S2I build takes place
USER 185
WORKDIR /tmp/maven-setup/
RUN ./prepare_m2_repo.sh $ENTANDO_VERSION
COPY ./contrib/maven-setup/settings-entando.xml $HOME/.m2/settings.xml
WORKDIR $HOME

# Add wildfly customizations  e.g. two datasources
USER root
RUN chown 185:0 $HOME/.m2/settings.xml && chmod ug+rw $HOME/.m2/settings.xml
#COPY ./contrib/wfbin/standalone.conf /opt/eap/bin/standalone.conf
COPY ./contrib/wfmodules/ /opt/eap/modules
COPY ./contrib/wfdata/entando /opt/eap/standalone/entando-data-template
COPY ./contrib/wildfly-configuration/standalone-openshift.xml /opt/eap/standalone/configuration/standalone-openshift.xml
COPY ./s2i/bin /usr/local/s2i
RUN chown -Rf 185:0 /usr/local/s2i  && chmod -Rf ug+rwx /usr/local/s2i && \
    chown 185:0 /opt/eap/bin/standalone.conf && chmod ug+rw /opt/eap/bin/standalone.conf && \
    chown 185:0 /opt/eap/standalone/configuration/standalone.xml && chmod ug+rw /opt/eap/standalone/configuration/standalone.xml && \
    chown -Rf 185:0 /opt/eap/standalone/entando-data-template  && chmod -Rf ug+rw /opt/eap/standalone/entando-data-template && \
    chown -Rf 185:0 /opt/eap/modules/org/apache/derby && chmod -Rf ug+rw /opt/eap/modules/org/apache/derby

USER 185
