FROM openjdk:8-slim

MAINTAINER Pietrangelo Masala <p.masala@entando.com>

#Environment Variables
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV JRE_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
ENV MAVEN_HOME=/usr/share/maven
ENV PROJECT_HOME=/opt/entando
ENV MVN_HOME=${PROJECT_HOME}/.m2
ENV ENTANDO_RELEASE=v5.0.0

RUN apt-get update && apt-get install --no-install-recommends -y maven imagemagick git \
&& apt-get autoclean -y \
&& mkdir -p ${PROJECT_HOME} && mkdir -p ${PROJECT_HOME}/.m2/repository && chown -R 1001:0 ${PROJECT_HOME}/ && chmod -R ug+w ${PROJECT_HOME}/

COPY settings.xml ${MAVEN_HOME}/conf/settings.xml

WORKDIR ${PROJECT_HOME}

# Install entando dependencies (archetypes) from v5.0.0 branch
# Set local maven repository to /opt/entando/.m2/repository
RUN cd ${PROJECT_HOME} \
&& git clone https://github.com/entando/entando-archetypes.git \
&& cd ${PROJECT_HOME}/entando-archetypes && git checkout ${ENTANDO_RELEASE} && mvn -Dmaven.repo.local=${MVN_HOME}/repository install \
&& chown -R 1001:0 ${MVN_HOME}/ && chmod -R ug+w ${MVN_HOME}/ \
&& rm -rf ${PROJECT_HOME}/entando-*