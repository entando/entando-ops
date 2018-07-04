FROM centos:7
MAINTAINER Pietrangelo Masala <p.masala@entando.com>
USER root
RUN useradd -ms /bin/bash entando
ENV JAVA_HOME /opt/jdk1.8.0_141
ENV JRE_HOME /opt/jdk1.8.0_141/jre
ENV MAVEN_HOME /usr/share/maven

COPY entando-components-enterprise/ /home/entando/entando-components-enterprise/
RUN chown -R entando:entando /home/entando/entando-components-enterprise && chmod 0775 -R /home/entando/entando-components-enterprise \
&& yum install -y curl git maven imagemagick wget \
&& cd /opt \
&& wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u141-b15/336fa29ff2bb4ef291e347e091f7f4a7/jdk-8u141-linux-x64.tar.gz" \
&& tar xzf jdk-8u141-linux-x64.tar.gz \
&& rm -f jdk-8u141-linux-x64.tar.gz \
&& rm -f /usr/bin/java /usr/bin/jar /usr/bin/javac \
&& cd jdk1.8.0_141/ \
&& ln -s /opt/jdk1.8.0_141/bin/java /usr/bin/java \
&& ln -s /opt/jdk1.8.0_141/bin/jar /usr/bin/jar \
&& ln -s /opt/jdk1.8.0_141/bin/javac /usr/bin/javac \
&& yum clean all -y
USER entando
RUN cd /home/entando \
&& git clone https://github.com/entando/entando-core.git \
&& git clone https://github.com/entando/entando-components.git \
&& git clone https://github.com/entando/entando-archetypes.git \
&& cd /home/entando/entando-core \
&& mvn clean install -DskipTests && mvn clean \
&& cd .. \
&& cd entando-components \
&& git checkout redhat_demo \
&& mvn clean install -DskipTests && mvn clean \
&& cd ..  \
&& cd entando-archetypes \
&& git checkout redhat_demo \
&& mvn clean install -DskipTests \
&& cp /home/entando/.m2/archetype-catalog.xml /home/entando/.m2/repository \
&& cd .. \
&& cd entando-components-enterprise \
&& mvn clean install -DskipTests && mvn clean \
&& cd .. \
&& mvn archetype:generate -B -Dfilter=entando -DarchetypeGroupId=org.entando.entando -DarchetypeArtifactId=entando-archetype-web-app-BPM -DgroupId=org.entando -DartifactId=demoweb-applicant -Dversion=1.0-SNAPSHOT -Dpackage=org.entando
WORKDIR /home/entando/demoweb-applicant

CMD ["mvn", "clean", "install", "-DskipTests", "jetty:run"]
EXPOSE 8080