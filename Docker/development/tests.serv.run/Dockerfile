FROM centos:7
LABEL MAINTAINER="Pietrangelo Masala <p.masala@entando.com>"
USER root
ENV MAVEN_VERSION 3.3.9
ENV JAVA_HOME /usr/lib/jvm/java
ENV JRE_HOME /usr/lib/jvm/jre
ENV MAVEN_HOME /usr/share/maven

RUN yum install -y curl git ImageMagick java-1.8.0-openjdk-devel \
&& mkdir -p /root/entando-5.0 \
&& cd /root/entando-5.0 \
&& git clone https://github.com/entando/entando-core \
&& git clone https://github.com/entando/entando-components \
&& git clone https://github.com/entando/entando-archetypes.git \
&& cd /tmp \
&& mkdir -p /usr/share/maven \
&& curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
| tar -xzC /usr/share/maven --strip-components=1 \
&& ln -s /usr/share/maven/bin/mvn /usr/bin/mvn \
&& yum clean all \
&& cd /root/entando-5.0/entando-core \
&& mvn clean install -DskipTests && mvn clean \
&& cd .. \
&& cd entando-components \
&& rm -f plugins/pom.xml
COPY plugins/pom.xml /root/entando-5.0/entando-components/plugins/
RUN rm -f /root/entando-5.0/entando-components/ui-bundles/pom.xml
COPY bundle/pom.xml /root/entando-5.0/entando-components/ui-bundles/
RUN cd /root/entando-5.0/entando-components \
&& mvn clean install -DskipTests && mvn clean \
&& cd .. \
&& cd entando-archetypes \
&& mvn clean install -DskipTests && mvn clean && cd .. \
&& cp /root/.m2/archetype-catalog.xml /root/.m2/repository \
&& mvn archetype:generate -B -Dfilter=entando -DarchetypeCatalog=local -DarchetypeGroupId=org.entando.entando -DarchetypeArtifactId=entando-archetype-entando-sample -DgroupId=org.entando -DartifactId=entando-sample -Dversion=1.0-SNAPSHOT -Dpackage=test.entando \
&& rm -f /root/entando-5.0/entando-sample/pom.xml \
&& rm -f /root/entando-5.0/entando-sample/src/main/filters/filter-development-unix.properties

COPY pom.xml /root/entando-5.0/entando-sample/
COPY filter-development-unix.properties /root/entando-5.0/entando-sample/src/main/filters/

WORKDIR /root/entando-5.0/entando-sample

CMD ["mvn", "jetty:run"]

EXPOSE 8080