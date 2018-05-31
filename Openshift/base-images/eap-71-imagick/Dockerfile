FROM registry.access.redhat.com/jboss-eap-7/eap71-openshift:latest

MAINTAINER Pietrangelo Masala "<p.masala@entando.com>"

LABEL maintainer="Pietrangelo Masala <p.masala@entando.com>" \
            name="entando-eap71-imagick" \
            vendor="Entando Srl" \
            version="1.1" \
            release="1.1" \
            license="lgplv2.1" \
            summary="This is an extended EAP 7.1 OpenShift image with the entando dependencies installed." \
            description="This is an extended EAP 7.1 OpenShift image with the entando dependencies installed." \
            url="https://central.entando.com" \
            run='docker run -itd --name ${NAME} \
            -u 185 \
            ${IMAGE}' \
            io.k8s.description="Platform for building and running Entando JavaEE applications on JBoss EAP 7.1" \
            io.k8s.display-name="JBoss EAP 7.1 with ImageMagick" \
            io.openshift.expose-services="8080:http" \
            io.openshift.tags="builder,javaee,eap,eap7,entando" \
            io.openshift.s2i.scripts-url="image:///usr/local/s2i" 

EXPOSE 8888

USER 0

RUN REPOLIST="rhel-7-server-rpms, rhel-7-server-optional-rpms" && \
yum -y update-minimal --disablerepo "*" --enablerepo rhel-7-server-rpms --setopt=tsflags=nodocs \
--security --sec-severity=Important --sec-severity=Critical && \
yum -y install --disablerepo "*" --enablerepo ${REPOLIST} --setopt=tsflags=nodocs ImageMagick libaio-devel && \
yum clean all && \
rm -rf /var/cache/yum/* && \
mkdir -p /licenses && \
chown -R 185:0 /opt/eap && chown -R 185:0 /home/jboss && \
chmod -R ug+w /opt/eap && chmod -R ug+rw /home/jboss

COPY licenses/ /licenses
COPY help/help.1 /help.1

USER 185