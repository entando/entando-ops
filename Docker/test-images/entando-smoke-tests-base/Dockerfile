FROM maven:3.5.4-jdk-8
ARG CHROME_DRIVER_VERSION=2.43
#Consume unused args not to break build
ARG ENTANDO_VERSION
ARG ENTANDO_IMAGE_VERSION

ENV ENTANDO_VERSION=$ENTANDO_IMAGE_VERSION \
    MAVEN_CONFIG=/home/maven/.m2/ \
    ENTANDO_RUN_HEADLESS=true

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
COPY --chown=maven:root ./entando-smoke-tests-base /entando-smoke-tests
RUN cd /entando-smoke-tests && mvn verify && chmod -Rf ug+rw /home/maven/.m2 && rm * -Rf

