FROM centos/postgresql-95-centos7@sha256:2868b2293d03b09f1a3e34caedee2472f760f2d9996c917626a15ab887255f53
LABEL io.openshift.s2i.destination="/opt/s2i/destination" \
      maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Postgresql Database Image for building and running Entando applications" \
      io.k8s.display-name="Postgresql Database Image for Entando 5"

ENV MAVEN_VERSION="3.5.2" \
    JAVA_HOME="/usr/lib/jvm/java-1.8.0"

#Change to root for installation operations
USER root
RUN INSTALL_PKGS="tar curl java-1.8.0-openjdk java-1.8.0-openjdk-devel" && \
  yum install -y --enablerepo=centosplus $INSTALL_PKGS && \
  rpm -V $INSTALL_PKGS && \
  yum clean all -y && \
  (curl -v https://www.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -zx -C /usr/local) && \
  ln -sf /usr/local/apache-maven-$MAVEN_VERSION/bin/mvn /usr/local/bin/mvn && \
  mkdir -p $HOME/.m2 && chmod ug+rw $HOME/.m2 && chown postgres:root $HOME/.m2

COPY pom.xml $HOME/pom.xml.bup
RUN chmod ug+rw $HOME/pom.xml.bup && chown postgres:root $HOME/pom.xml.bup
COPY settings-entando.xml $HOME/.m2/settings.xml
RUN chmod ug+rw $HOME/.m2/settings.xml && chown postgres:root $HOME/.m2/settings.xml

#The user 'postgres' is 26, and openshift requires the numeric:
USER 26
#Run all of this as postgres as this will be the user under which the S2I build takes place
RUN cd $HOME && \
  mvn archetype:generate -DgroupId=org.sample -DartifactId=sample -DinteractiveMode=false \
  -DarchetypeGroupId=org.entando.entando -DarchetypeArtifactId=entando-archetype-webapp-generic -DarchetypeVersion=4.3.2 && \
  mv pom.xml.bup sample/pom.xml -f
#Has to be run in a separate RUN or it takes all the preceding commands before & to be async. Will be a very thin but discarded layer
RUN cd $HOME/sample && \
  mvn jetty:run 2>&1 > db_creation.log & cd $HOME/sample &&\
  jetty_pid=$! && \
  echo "jetty: $jetty_pid" && \
  for i in {1..150} ;  \
      do sleep 6 && tail db_creation.log -n 5; \
      if fgrep --quiet "Started Jetty Server" db_creation.log; \
        then echo "Jetty started" &&  kill $jetty_pid && break; \
      fi; \
  done; \
  cd $HOME && rm $HOME/sample -rf && \
  chmod -Rf ug+rw $HOME/.m2 && chown -Rf postgres:root $HOME/.m2

#use root to ensure chmod works
USER root

#Add scripts
COPY ./s2i/bin/ $STI_SCRIPTS_PATH
RUN chmod -Rf ug+rw $STI_SCRIPTS_PATH && chown -Rf postgres:root $STI_SCRIPTS_PATH

#Restore secure settings file
COPY settings-secure.xml $HOME/.m2/settings.xml
RUN chmod ug+rw $HOME/.m2/settings.xml && chown postgres:root $HOME/.m2/settings.xml
RUN mkdir -p /opt/s2i/destination && chmod -R ug+rw /opt/s2i/destination && chown -R postgres:root /opt/s2i/destination

#And end by making the user postgres again
USER 26
