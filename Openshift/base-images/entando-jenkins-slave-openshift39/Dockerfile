FROM openshift/jenkins-slave-maven-centos7:v3.9
COPY maven-setup /tmp/maven-setup
USER root
RUN chmod -Rf ug+rw /tmp/maven-setup/ && chown -Rf 1001:root /tmp/maven-setup/

#Prepare the Maven repo as 1001
USER 1001
WORKDIR /tmp/maven-setup/
RUN ./prepare_m2_repo.sh 5.0.1
WORKDIR /var/lib/origin

USER 1001
