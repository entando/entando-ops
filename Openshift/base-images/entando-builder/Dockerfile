
# entando-builder
FROM centos:7.4.1708
MAINTAINER Pietrangelo Masala <p.masala@entando.com>

### Atomic/OpenShift Labels
LABEL name="entando/entando-openshift-base-image" \
      maintainer="p.masala@entando.com" \
      vendor="Entando Srl" \
      version="1" \
      release="1" \
      summary="Entando base image for running on OpenShift environments" \
      description="This base image includes all needed dependencies for running an entando project" \
      url="https://www.entando.com" \
      run='docker run -tdi --name ${NAME} \
      -u 123456 \
      ${IMAGE}' \
      io.k8s.description="Entando base image for running on OpenShift environments" \
      io.k8s.display-name="Entando base image 1.1" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="entando,ux,openshift,docker" \
      io.openshift.s2i.scripts-url=image:///usr/local/s2i

#Environment Variables
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0
ENV JRE_HOME=/usr/lib/jvm/jre-1.8.0
ENV MAVEN_HOME=/usr/share/maven
ENV MAVEN_LOCAL_REPO=/opt/entando/repository
ENV MAVEN_RELEASE=3.3.9
ENV APP_ROOT=/opt/entando
ENV PATH=${APP_ROOT}/bin:${PATH}
ENV HOME=${APP_ROOT}

#COPY bin/ ${APP_ROOT}/bin/
# set default path for maven local repository to ${APP_ROOT}/repository
COPY settings.xml /tmp/settings.xml
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/local/s2i

# Install Entando dependencies, software requirements and users
RUN adduser --system -u 10001 10001 \
&& yum -y install git java-1.8.0-openjdk-devel ImageMagick git wget \
&& mkdir -p ${APP_ROOT} && mkdir -p ${MAVEN_LOCAL_REPO} \
#&& chmod -R u+x ${APP_ROOT}/bin \
&& chgrp -R 0 ${APP_ROOT} && chown -R 10001:0 ${APP_ROOT} \
&& chmod -R ugo=rw ${APP_ROOT} /etc/passwd \
&& cd /tmp && wget http://www.eu.apache.org/dist/maven/maven-3/${MAVEN_RELEASE}/binaries/apache-maven-${MAVEN_RELEASE}-bin.tar.gz \
&& tar xzf apache-maven-${MAVEN_RELEASE}-bin.tar.gz \
&& mkdir ${MAVEN_HOME} \
&& cd apache-maven-${MAVEN_RELEASE}/ && cp -R * ${MAVEN_HOME} && cd .. && rm -rf /tmp/apache-maven* \
&& alternatives --install /usr/bin/mvn mvn ${MAVEN_HOME}/bin/mvn 1 \
&& alternatives --auto mvn \
&& rm -f /usr/share/maven/conf/settings.xml \
&& cp /tmp/settings.xml /usr/share/maven/conf/settings.xml \
&& cd ${APP_ROOT} \
&& git clone https://github.com/entando/entando-core.git \
&& git clone https://github.com/entando/entando-components.git \
&& git clone https://github.com/entando/entando-archetypes.git \
&& cd entando-core && mvn -DskipTests install && mvn clean && cd .. \
&& cd entando-components && mvn -DskipTests install && mvn clean && cd .. \
&& cd entando-archetypes && mvn -DskipTests install && mvn clean && cd .. \
&& rm -rf entando-* \
&& chgrp -R 0 ${APP_ROOT} && chown -R 10001:0 ${APP_ROOT} \
&& chmod -R ugo=rwx ${APP_ROOT} \
&& yum -y clean all

# run as user 10001 for OpenShift security constraints
USER 10001
WORKDIR ${APP_ROOT}

RUN chgrp -R 0 ${APP_ROOT} && chown -R 10001:0 ${APP_ROOT} \
&& chmod -R ug=rw ${APP_ROOT}

EXPOSE 8080

CMD ["/usr/local/s2i/usage"]