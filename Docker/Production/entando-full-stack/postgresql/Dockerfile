ARG ENTANDO_VERSION_TO_BUILD
#FROM entando/entando-wildfly12-quickstart-docker:5.0.1-SNAPSHOT
FROM entando/entando-postgresql95-base:$ENTANDO_VERSION_TO_BUILD
ENV POSTGRESQL_USER=agile \
    POSTGRESQL_PASSWORD=agile \
    POSTGRESQL_ADMIN_PASSWORD=postgres \
    POSTGRESQL_DATABASE=entandoPort \
    POSTGRESQL_DATABASE2=entandoServ \
    POSTGRESQL_MAX_PREPARED_TRANSACTIONS=0 \
    POSTGRESQL_SHARED_BUFFERS=32MB

RUN cd /opt/s2i/destination/ && \
    echo  "ENTANDO_VERSION=$ENTANDO_VERSION" && \
    mvn archetype:generate -DgroupId=org.sample \
      -DartifactId=entando \
      -DarchetypeGroupId=org.entando.entando \
      -DarchetypeArtifactId=entando-archetype-web-app-BPM \
      -DarchetypeVersion=$ENTANDO_VERSION \
      -DinteractiveMode=false --settings $HOME/.m2/settings.xml \
      -Dmaven.repo.local=$HOME/.m2/repository && \
    mv entando src && \
    $STI_SCRIPTS_PATH/assemble && \
    rm -Rf $HOME/.m2/repository/*
