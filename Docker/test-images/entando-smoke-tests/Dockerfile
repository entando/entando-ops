ARG ENTANDO_IMAGE_VERSION
#Consume unused arg not to break build
ARG ENTANDO_VERSION

FROM entando/entando-smoke-tests-base:$ENTANDO_IMAGE_VERSION
RUN cd /entando-smoke-tests && wget https://github.com/entando/entando-QE/archive/smoke-tests.zip && \
      unzip  smoke-tests.zip && rm smoke-tests.zip  && \
      mv entando-QE-smoke-tests/Selenium_APPBUILDER/* . && rm -Rf entando-QE-smoke-tests && \      
      mvn clean verify -DskipTests
WORKDIR /entando-smoke-tests
ENV MAVEN_CONFIG=/home/maven/.m2/
