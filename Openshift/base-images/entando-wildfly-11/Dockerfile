# This image provides a base for building and running WildFly applications.
# It builds using maven and runs the resulting artifacts on WildFly 11.0.0 Final

FROM openshift/wildfly-110-centos7

MAINTAINER Ampie Barnard <a.barnard@entando.com>
#Ampie: lets figure out which ones we can eliminate
EXPOSE 8080 9990 8181 8888 11211 11222 57600 7600 45700 45688 23364 4712 4713

LABEL io.k8s.description="Platform for building and running Entando applications on WildFly 11.0.0.Final" \
      io.k8s.display-name="Entando 5 on WildFly 11.0.0.Final"
USER root
# Install ImageMagick, ....
RUN INSTALL_PKGS=ImageMagick && \
    yum install -y --enablerepo=centosplus $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

USER 1001
COPY pom.xml $HOME/pom.xml.bup
RUN cd $HOME && \
  mvn archetype:generate -DgroupId=org.sample -DartifactId=sample \
  -DarchetypeGroupId=org.entando.entando -DarchetypeArtifactId=entando-archetype-webapp-generic -DinteractiveMode=false && \
  mv pom.xml.bup sample/pom.xml -f && \
  cd $HOME/sample && \
  mvn package -Dmaven.repo.local=$HOME/.m2/repository && \
  cd $HOME && rm $HOME/sample -r && \
  chmod -R ug+rw $HOME && chown -R 1001:0 $HOME/

# Add wildfly customizations -Ampie: we can do this from the maven project too.
USER root
COPY ./contrib/wfcfg/standalone-ha.xml /wildfly/standalone/configuration/standalone-ha.xml
RUN chown 1001:0 /wildfly/standalone/configuration/standalone-ha.xml && chmod ug+rw /wildfly/standalone/configuration/standalone-ha.xml

#Maven settings to ensure all repos only serve released artifacts
COPY settings.xml $HOME/.m2/settings.xml
RUN chown 1001:0 $HOME/.m2/settings.xml && chmod ug+rw $HOME/.m2/settings.xml

# Copy the S2I scripts customized for Entando to $STI_SCRIPTS_PATH
COPY ./s2i/bin/assemble $STI_SCRIPTS_PATH/assemble
COPY ./s2i/bin/run $STI_SCRIPTS_PATH/run
USER 1001