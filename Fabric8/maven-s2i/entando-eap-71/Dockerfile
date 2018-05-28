FROM registry.access.redhat.com/jboss-eap-7/eap71-openshift:latest

MAINTAINER Ampie Barnard "<a.barnard@entando.com>"

LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
            name="entando-eap71" \
            vendor="Entando Srl" \
            version="1.0" \
            release="5.0.0-SNAPSHOT" \
            license="lgplv2.1" \
            summary="This is an extended EAP 7.1 OpenShift image with the entando dependencies installed." \
            description="This is an extended EAP 7.1 OpenShift image with the entando dependencies installed." \
            io.k8s.description="Platform for building and running JavaEE applications on JBoss EAP 7.1" \
            io.k8s.display-name="JBoss EAP 7.1" \
            io.openshift.expose-services="8080:http" \
            io.openshift.tags="builder,javaee,eap,eap7" \
            io.openshift.s2i.scripts-url="image:///usr/local/s2i" 

EXPOSE 8888
USER root

COPY contrib/wfcfg/standalone-ha.xml /opt/eap/standalone/config/standalone-openshift.xml
RUN chmod ug+rw /opt/eap/standalone/config/standalone-openshift.xml && chown 185:root /opt/eap/standalone/config/standalone-openshift.xml

# Copy the S2I scripts customized for Entando to $STI_SCRIPTS_PATH
COPY ./s2i/bin/assemble $STI_SCRIPTS_PATH/assemble
RUN chmod -Rf ug+xrw $STI_SCRIPTS_PATH/assemble && chown -Rf 185:root $STI_SCRIPTS_PATH/assemble

USER 185
