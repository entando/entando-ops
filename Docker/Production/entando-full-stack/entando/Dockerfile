ARG ENTANDO_VERSION_TO_BUILD
FROM 127.0.0.1:5000/entando/entando-wildfly12-base:$ENTANDO_VERSION_TO_BUILD
RUN export PREPARE_DB=false && \
    cd /opt/s2i/destination/ && \
    mvn archetype:generate -B --settings $HOME/.m2/settings.xml \
        -Dfilter=entando \
        -DarchetypeGroupId=org.entando.entando \
        -DarchetypeArtifactId=entando-archetype-web-app-BPM \
        -DarchetypeVersion="${ENTANDO_VERSION}" \
        -DgroupId=org.entando \
        -DartifactId=entando \
        -Dversion=1.0 \
        -Dpackage=org.entando && \
    mv entando src && \
    ${STI_SCRIPTS_PATH}/assemble && \
    rm -Rf $HOME/.m2/repository && \
    rm -Rf src && \
    rm -Rf $HOME/src $HOME/target $HOME/pom.xml $HOME/build.xml
