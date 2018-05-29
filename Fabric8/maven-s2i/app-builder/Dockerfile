FROM centos/nodejs-8-centos7:latest

ENV NPM_CONFIG_LOGLEVEL warn

ENV USE_MOCKS false
ENV DOMAIN //localhost:8080/entando


USER 1001
# Install and configure `serve`. Download project from entando repository
RUN source /opt/rh/rh-nodejs8/enable && \
  npm install -g serve && \
  git clone https://github.com/entando/app-builder.git && \
  git clone https://github.com/entando/entando-components.git && \
  echo [\"entando-plugin-jpkiebpm\"] > app-builder/entando-plugins-config/plugins.json && \
  cd entando-components/plugins/entando-plugin-jpkiebpm/app-builder && npm install && \
  cd /opt/app-root/src/app-builder && npm install && \
  npm run import-plugins && \
  cd /opt/app-root/src && \
  chown -R 1001:0 app-builder && chmod -R ug+rw app-builder && \
  chown -R 1001:0 entando-components && chmod -R ug+rw entando-components

COPY start.sh /start.sh
USER root
RUN chmod a+x /start.sh

USER 1001
WORKDIR /opt/app-root/src/app-builder
CMD /start.sh
EXPOSE 3000

