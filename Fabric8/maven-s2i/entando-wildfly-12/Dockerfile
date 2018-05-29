# This image provides a base for building and running Entando WildFly based applications.
# It builds using maven and runs the resulting artifacts on WildFly 12.0.0 Final

FROM openshift/wildfly-120-centos7
LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Platform for building and running Entando applications on WildFly 12.0.0.Final" \
      io.k8s.display-name="Entando on WildFly 12.0.0.Final"

ENV ENTANDO_VERSION="5.0.0-SNAPSHOT"

#Use root to install stuff
USER root
# Install ImageMagick, ....
RUN INSTALL_PKGS=ImageMagick && \
    yum install -y --enablerepo=centosplus $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

#stay in root to ensure chmod works
COPY ./contrib/maven-setup /tmp/maven-setup
RUN chmod -Rf ug+rw /tmp/maven-setup && chown -Rf 1001:root /tmp/maven-setup

#Run all of this as 1001 as this will be the user under which the S2I build takes place
USER 1001
WORKDIR /tmp/maven-setup/
RUN ./prepare_m2_repo.sh $ENTANDO_VERSION
WORKDIR $HOME

# Add wildfly customizations  e.g. two datasources
USER root
COPY ./contrib/wfcfg/standalone-ha.xml /wildfly/standalone/configuration/standalone-openshift.xml
RUN chown 1001:0 /wildfly/standalone/configuration/standalone-openshift.xml && chmod ug+rw /wildfly/standalone/configuration/standalone-openshift.xml

# Copy the S2I scripts customized for Entando to $STI_SCRIPTS_PATH
COPY ./s2i/bin/assemble $STI_SCRIPTS_PATH/assemble
COPY ./s2i/bin/run $STI_SCRIPTS_PATH/run
RUN chmod -Rf ug+xrw $STI_SCRIPTS_PATH && chown -Rf 1001:root $STI_SCRIPTS_PATH

USER 1001
