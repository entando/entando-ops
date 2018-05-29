FROM centos/nodejs-8-centos7:latest

ENV NPM_CONFIG_LOGLEVEL warn

ENV USE_MOCKS false
ENV DOMAIN //localhost:8080/entando


USER 1001
# Install and configure `serve`. Download project from entando repository
RUN source /opt/rh/rh-nodejs8/enable && \
  npm install -g serve && \
  git clone https://github.com/entando/mapp-engine-admin-app.git && \
  cd /opt/app-root/src/mapp-engine-admin-app && npm install && \
  npm run import-plugins && \
  cd /opt/app-root/src && \
  chown -R 1001:0 mapp-engine-admin-app && chmod -R ug+rw mapp-engine-admin-app

COPY start.sh /start.sh
USER root
RUN chmod a+x /start.sh
USER 1001

WORKDIR /opt/app-root/src/mapp-engine-admin-app
CMD /start.sh
EXPOSE 3000
