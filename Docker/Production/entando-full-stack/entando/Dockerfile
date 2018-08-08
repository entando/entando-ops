ARG ENTANDO_VERSION_TO_BUILD
FROM entando/entando-wildfly12-quickstart-docker:$ENTANDO_VERSION_TO_BUILD

COPY settings.xml /tmp/settings.xml
RUN cd /tmp && mvn archetype:generate -B --settings settings.xml\
        -Dfilter=entando \
        -DarchetypeGroupId=org.entando.entando \
        -DarchetypeArtifactId=entando-archetype-web-app-BPM \
        -DarchetypeVersion="${ENTANDO_VERSION}" \
        -DgroupId=org.entando \
        -DartifactId=entando \
        -Dversion=1.0 \
        -Dpackage=org.entando && \
    cd /tmp/entando && \
    mvn package -Pproduction-jboss --settings /tmp/settings.xml \
        -DskipTests \
        -Dprofile.datasource.jndiname.servdb=${SERVDB_JNDI} \
        -Dprofile.datasource.jndiname.portdb=${PORTDB_JNDI} \
        -Dprofile.log.file.prefix=/entando-data/logs/log \
        -Dprofile.resources.path=/entando-data/resources \
        -Dprofile.resources.path.protected=/entando-data/protected \
        -Dprofile.index.path=/entando-data/indexdir \
        -Dprofile.log.activeFileOutput=true \
        -Dprofile.application.baseurl.protocol=http && \
    mv /tmp/entando/target/entando.war /wildfly/standalone/deployments/ && \
    rm /tmp/entando -rf * rm $HOME/.m2/repository/ -rf

