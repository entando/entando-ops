FROM centos/postgresql-95-centos7@sha256:2868b2293d03b09f1a3e34caedee2472f760f2d9996c917626a15ab887255f53
ENV MAVEN_VERSION=3.5.2

USER root
RUN  INSTALL_PKGS="tar curl java-1.8.0-openjdk java-1.8.0-openjdk-devel" && \
  yum install -y --enablerepo=centosplus $INSTALL_PKGS && \
  rpm -V $INSTALL_PKGS && \
  yum clean all -y && \
  (curl -v https://www.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -zx -C /usr/local) && \
  ln -sf /usr/local/apache-maven-$MAVEN_VERSION/bin/mvn /usr/local/bin/mvn && \
  mkdir -p $HOME/.m2 && chown postgres $HOME/.m2
COPY pom.xml $HOME/pom.xml.bup
RUN chown postgres $HOME/pom.xml.bup
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0
RUN cd $HOME && ls -al &&\
  mvn archetype:generate -Dmaven.repo.local=$HOME/.m2/repository -DgroupId=org.sample -DartifactId=sample \
  -DarchetypeGroupId=org.entando.entando -DarchetypeArtifactId=entando-archetype-webapp-generic -DinteractiveMode=false && \
  mv pom.xml.bup sample/pom.xml -f && \
  cd $HOME/sample && \
  mvn package -Dmaven.repo.local=$HOME/.m2/repository && \
  cd $HOME && rm $HOME/sample -r && \
  chmod -R ug+rw $HOME/.m2 && chown -R 1001:0 $HOME/.m2
RUN mkdir /opt/s2i %% mkdir /opt/s2i/destination && chmod -Rf ug+rw /opt/s2i/destination
COPY ./s2i/bin/ $STI_SCRIPTS_PATH
RUN chown -R postgres $STI_SCRIPTS_PATH
USER 26
LABEL io.openshift.s2i.destination=/opt/s2i/destination
