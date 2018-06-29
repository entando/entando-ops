FROM centos/nodejs-8-centos7:latest

ENV NPM_CONFIG_LOGLEVEL=warn \
    USE_MOCKS=false  \
    APP_BUILDER_BRANCH=v5.0.1-release  \
    ENTANDO_COMPONENTS_BRANCH=v5.0.1-dev \
    DOMAIN_MARKER=SOME_ARB_STRING_TO_REPLACE_LATER_81231
ENV DOMAIN=$DOMAIN_MARKER

USER root
RUN chmod ug+rw /opt

USER 1001
# Install and configure `serve`. Download project from entando repository
RUN  mkdir /opt/testing && \
  source /opt/rh/rh-nodejs8/enable && \
  npm install -g serve && \
  git clone --branch $APP_BUILDER_BRANCH https://github.com/entando/app-builder.git && \
  git clone --branch $ENTANDO_COMPONENTS_BRANCH https://github.com/entando/entando-components.git && \
  echo "[\"entando-plugin-jpkiebpm\"]" > app-builder/entando-plugins-config/plugins.json && \
  cd entando-components/plugins/entando-plugin-jpkiebpm/app-builder && npm install && \
  cd /opt/app-root/src/app-builder && npm install && npm run import-plugins && npm run build && \
  cd /opt/app-root/src/ && mv app-builder/build /opt/app-builder && rm -rf app-builder entando-components && \
  chmod -R ug+rw /opt/app-builder

COPY start.sh /opt/app-builder/start.sh
USER root
RUN chmod a+x /opt/app-builder/start.sh

USER 1001
WORKDIR /opt/app-builder
CMD /opt/app-builder/start.sh
#because the npm serve package cannot make up its mind
EXPOSE 3000 5000

