FROM centos/nodejs-8-centos7:latest

ENV NPM_CONFIG_LOGLEVEL=warn \
    USE_MOCKS=false \
    DOMAIN_MARKER=SOME_ARB_STRING_TO_REPLACE_LATER_81231
ENV DOMAIN=$DOMAIN_MARKER


USER 1001
# Install and configure `serve`. Download project from entando repository
RUN source /opt/rh/rh-nodejs8/enable && \
  npm install -g serve && \
  git clone --branch v5.0.0 https://github.com/entando/mapp-engine-admin-app.git && \
  cd /opt/app-root/src/mapp-engine-admin-app && npm install && \
  npm run import-plugins && npm run build && \
  cd /opt/app-root/src && \
  chown -R 1001:0 mapp-engine-admin-app && chmod -R ug+rw mapp-engine-admin-app

COPY start.sh /opt/app-root/src/mapp-engine-admin-app/start.sh
USER root
RUN chmod a+x /opt/app-root/src/mapp-engine-admin-app/start.sh
USER 1001

WORKDIR /opt/app-root/src/mapp-engine-admin-app
CMD /opt/app-root/src/mapp-engine-admin-app/start.sh
EXPOSE 3000
