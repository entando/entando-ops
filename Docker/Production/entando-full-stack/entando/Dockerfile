ARG ENTANDO_VERSION_TO_BUILD
#FROM entando/entando-wildfly12-quickstart-docker:5.0.1-SNAPSHOT
FROM entando/entando-wildfly12-base:$ENTANDO_VERSION_TO_BUILD

RUN cd /tmp && mvn archetype:generate -B --settings $HOME/.m2/settings.xml \
        -Dfilter=entando \
        -DarchetypeGroupId=org.entando.entando \
        -DarchetypeArtifactId=entando-archetype-web-app-BPM \
        -DarchetypeVersion="${ENTANDO_VERSION}" \
        -DgroupId=org.entando \
        -DartifactId=entando \
        -Dversion=1.0 \
        -Dpackage=org.entando && \
    cd /tmp/entando && \


