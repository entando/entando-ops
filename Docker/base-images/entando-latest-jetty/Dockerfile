FROM openjdk:8-slim

LABEL maintainer="Pietrangelo Masala <p.masala@entando.com>"

#Environment Variables
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV JRE_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
ENV MAVEN_HOME=/usr/share/maven
ENV HOME=/opt/entando

RUN apt-get update && apt-get install --no-install-recommends -y maven imagemagick git \
&&  apt-get autoclean -y \
&& mkdir -p /opt/entando && mkdir -p /opt/entando/.m2/repository && chown -R 1001:0 /opt/entando/ && chmod -R ug+w /opt/entando/

# run as user 1001 for OpenShift security constraints
USER 1001

# Install entando dependencies (core, components, archetypes) from master branch
# Set local maven repository to /opt/entando/.m2/repository
# Create a symbolic link to archetype-catalog.xml file in repository directory to have local archetypes updated
RUN cd /opt/entando \
&& git clone https://github.com/entando/entando-core.git \
&& git clone https://github.com/entando/entando-components.git \
&& git clone https://github.com/entando/entando-archetypes.git \
&& cd entando-core && mvn -Dmaven.repo.local=/opt/entando/.m2/repository install -DskipTests && mvn clean && cd .. \
&& cd entando-components && mvn -Dmaven.repo.local=/opt/entando/.m2/repository install -DskipTests && mvn clean && cd .. \
&& cd entando-archetypes && mvn -Dmaven.repo.local=/opt/entando/.m2/repository install && mvn clean \
&& chmod -R ug+w $HOME/.m2/repository/ \
&& rm -rf $HOME/entando-*
#&& cd $HOME/.m2/repository && ln -s $HOME/.m2/archetype-catalog.xml .

WORKDIR $HOME