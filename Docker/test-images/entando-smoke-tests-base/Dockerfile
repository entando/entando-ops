ARG ENTANDO_IMAGE_VERSION
FROM entando/entando-dependencies-base:$ENTANDO_IMAGE_VERSION as dependencies
FROM maven:3.5.4-jdk-8
ARG CHROME_DRIVER_VERSION=2.43
ARG ENTANDO_VERSION
ARG MAVEN_MIRROR_FOR_DOCKER_BUILDS

ENV ENTANDO_VERSION=$ENTANDO_IMAGE_VERSION \
    MAVEN_CONFIG=/home/maven/.m2/ \
    ENTANDO_RUN_HEADLESS=true \
    MAVEN_MIRROR_URL="${MAVEN_MIRROR_FOR_DOCKER_BUILDS}" \
    ENTANDO_COMMON_PATH="/entando-common"

# Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
	&& echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
	&& apt-get update -qqy \
	&& apt-get -qqy install google-chrome-stable \
	&& rm /etc/apt/sources.list.d/google-chrome.list \
	&& rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
	&& sed -i 's/"$HERE\/chrome"/"$HERE\/chrome" --no-sandbox/g' /opt/google/chrome/google-chrome

# ChromeDriver
RUN wget --no-verbose -O /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip \
	&& rm -rf /opt/chromedriver \
	&& unzip /tmp/chromedriver_linux64.zip -d /opt \
	&& rm /tmp/chromedriver_linux64.zip \
	&& mv /opt/chromedriver /opt/chromedriver-$CHROME_DRIVER_VERSION \
	&& chmod 755 /opt/chromedriver-$CHROME_DRIVER_VERSION \
	&& ln -fs /opt/chromedriver-$CHROME_DRIVER_VERSION /usr/bin/chromedriver

RUN useradd -m -s /bin/bash -g root maven
USER maven
COPY --chown=maven:root --from=dependencies $ENTANDO_COMMON_PATH $ENTANDO_COMMON_PATH
COPY --chown=maven:root --from=dependencies /opt/app-root/src/.m2/settings.xml  ${MAVEN_CONFIG}/settings.xml
COPY --chown=maven:root ./entando-smoke-tests-base /entando-smoke-tests
RUN $ENTANDO_COMMON_PATH/inject-maven-docker-build-mirror.sh && \
    cd /entando-smoke-tests && mvn verify && chmod -Rf ug+rw /home/maven/.m2 && rm * -Rf && \
    $ENTANDO_COMMON_PATH/restore-settings-xml.sh && \
    find $HOME/.m2 -name "_remote.repositories" -type f -delete && \
    find $HOME/.m2 -name "entando*SNAPSHOT*" -type f -delete && \
    find $HOME/.m2 -name "*.lastUpdated" -type f -delete && \
    find $HOME/.m2 -name "resolver-status.properties" -type f -delete
ENV MAVEN_MIRROR_URL=""

