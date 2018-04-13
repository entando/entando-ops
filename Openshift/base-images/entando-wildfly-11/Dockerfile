# This image provides a base for building and running WildFly applications.
# It builds using maven and runs the resulting artifacts on WildFly 11.0.0 Final

FROM openshift/wildfly-110-centos7
LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Platform for building and running Entando applications on WildFly 11.0.0.Final" \
      io.k8s.display-name="Entando 5 on WildFly 11.0.0.Final"

#Ampie: lets figure out which ones we can eliminate
EXPOSE 8080 9990 8181 8888 11211 11222 57600 7600 45700 45688 23364 4712 4713
#Use root to install stuff
USER root
# Install ImageMagick, ....
RUN INSTALL_PKGS=ImageMagick && \
    yum install -y --enablerepo=centosplus $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

#stay in root to ensure chmod works
COPY pom.xml $HOME/pom.xml.bup
RUN chmod ug+rw $HOME/pom.xml.bup && chown 1001:root $HOME/pom.xml.bup
COPY settings-entando.xml $HOME/.m2/settings.xml
RUN chmod ug+rw $HOME/.m2/settings.xml && chown 1001:root $HOME/.m2/settings.xml

#Run all of this as 1001 as this will be the user under which the S2I build takes place
USER 1001

RUN cd $HOME && \
  mvn archetype:generate -DgroupId=org.sample -DartifactId=sample \
  -DarchetypeGroupId=org.entando.entando -DarchetypeArtifactId=entando-archetype-webapp-generic -DarchetypeVersion=4.3.2 \
  -DinteractiveMode=false && \
  mv pom.xml.bup sample/pom.xml -f && \
  cd $HOME/sample && \
  mvn package && \
  cd $HOME && rm $HOME/sample -r && \
  chmod -Rf ug+rw $HOME/.m2 && chown -Rf 1001:root $HOME/.m2

# Add wildfly customizations -Ampie: we can do this from the maven project too.
USER root
COPY ./contrib/wfcfg/standalone-ha.xml /wildfly/standalone/configuration/standalone-ha.xml
RUN chown 1001:0 /wildfly/standalone/configuration/standalone-ha.xml && chmod ug+rw /wildfly/standalone/configuration/standalone-ha.xml

#Maven settings to ensure all repos only serve released artifacts
COPY settings-secure.xml $HOME/.m2/settings.xml
RUN chown 1001:0 $HOME/.m2/settings.xml && chmod ug+rw $HOME/.m2/settings.xml

# Copy the S2I scripts customized for Entando to $STI_SCRIPTS_PATH
COPY ./s2i/bin/assemble $STI_SCRIPTS_PATH/assemble
RUN chmod -Rf ug+xrw $STI_SCRIPTS_PATH/assemble && chown -Rf 1001:root $STI_SCRIPTS_PATH/assemble
COPY ./s2i/bin/run $STI_SCRIPTS_PATH/run
RUN chmod -Rf ug+xrw $STI_SCRIPTS_PATH/run && chown -Rf 1001:root $STI_SCRIPTS_PATH/run

USER 1001