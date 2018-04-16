FROM openjdk:8-slim

LABEL maintainer="Pietrangelo Masala <p.masala@entando.com>"

#Environment Variables
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV JRE_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
ENV MAVEN_HOME=/usr/share/maven
ENV PROJECT_HOME=/opt/entando
ENV MVN_HOME=${PROJECT_HOME}/.m2

RUN apt-get update && apt-get install --no-install-recommends -y maven imagemagick git \
&& apt-get autoclean -y \
&& mkdir -p ${PROJECT_HOME} && mkdir -p ${PROJECT_HOME}/.m2/repository && chown -R 1001:0 ${PROJECT_HOME}/ && chmod -R ug+w ${PROJECT_HOME}/

COPY archetype-catalog.xml ${MVN_HOME}/archetype-catalog.xml
COPY settings.xml ${MAVEN_HOME}/conf/settings.xml

RUN chown 1001:0 ${PROJECT_HOME}/.m2/archetype-catalog.xml && chmod ug+w ${PROJECT_HOME}/.m2/archetype-catalog.xml


WORKDIR ${PROJECT_HOME}

# run as user 1001 for OpenShift security constraints
USER 1001

# Install entando dependencies (core, components, archetypes) from master branch
# Set local maven repository to /opt/entando/.m2/repository
# Create a symbolic link to archetype-catalog.xml file in repository directory to have local archetypes updated
RUN cd ${PROJECT_HOME} \
&& git clone https://github.com/entando/entando-core.git \
&& git clone https://github.com/entando/entando-components.git \
&& git clone https://github.com/entando/entando-archetypes.git \
&& cd entando-core && mvn -Dmaven.repo.local=${MVN_HOME}/repository install -DskipTests && cd .. \
&& cd entando-components && mvn -Dmaven.repo.local=${MVN_HOME}/repository install -DskipTests && cd .. \
&& cd entando-archetypes && mvn -Dmaven.repo.local=${MVN_HOME}/repository install \
&& chmod -R ug+w ${MVN_HOME}/repository/ \
&& rm -rf ${PROJECT_HOME}/entando-* \
&& cd ${MVN_HOME}/repository && ln -s ${MVN_HOME}/archetype-catalog.xml .

expose 8080