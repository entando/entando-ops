FROM centos/nodejs-8-centos7:latest
ARG MAPP_ENGINE_BRANCH

ENV NPM_CONFIG_LOGLEVEL=warn \
    USE_MOCKS=false \
    DOMAIN_MARKER=SOME_ARB_STRING_TO_REPLACE_LATER_81231
ENV DOMAIN=$DOMAIN_MARKER

USER root
RUN chmod ug+rw /opt

USER 1001
# Install and configure `serve`. Download project from entando repository
RUN source /opt/rh/rh-nodejs8/enable && \
  npm install -g serve && \
  git clone --branch $MAPP_ENGINE_BRANCH https://github.com/entando/mapp-engine-admin-app.git && \
  cd /opt/app-root/src/mapp-engine-admin-app && npm install && \
  npm run import-plugins && npm run build && \
  cd /opt/app-root/src && mv mapp-engine-admin-app/build /opt/mapp-engine-admin-app && rm -rf mapp-engine-admin-app && \
  chmod -R ug+rw /opt/mapp-engine-admin-app

COPY start.sh /opt/mapp-engine-admin-app/start.sh
USER root
RUN chmod a+x /opt/mapp-engine-admin-app/start.sh
USER 1001

WORKDIR /opt/mapp-engine-admin-app
CMD /opt/mapp-engine-admin-app/start.sh
EXPOSE 3000 5000
