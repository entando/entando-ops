FROM centos/nodejs-8-centos7:latest
ARG DIGITAL_EXCHANGE_UI_ENABLED=false
ARG APP_BUILDER_BRANCH
ARG ENTANDO_COMPONENTS_BRANCH
ENV NPM_CONFIG_LOGLEVEL=warn \
    USE_MOCKS=false  \
    DIGITAL_EXCHANGE_UI_ENABLED=${DIGITAL_EXCHANGE_UI_ENABLED} \
    DOMAIN_MARKER=SOME_ARB_STRING_TO_REPLACE_LATER_81231 \
    CLIENT_ID=appbuilder \
    CLIENT_SECRET_MARKER=SOME_ARB_STRING_TO_REPLACE_LATER_909812

ENV DOMAIN=$DOMAIN_MARKER \
    CLIENT_SECRET=$CLIENT_SECRET_MARKER

USER root
RUN chmod ug+rw /opt
USER 1001
# Install and configure `serve`. Download project from entando repository
RUN  source /opt/rh/rh-nodejs8/enable && \
  npm i -g npm && \
  npm i -g serve && \
  git clone --branch $APP_BUILDER_BRANCH https://github.com/entando/app-builder.git && \
  cd /opt/app-root/src/app-builder && npm install && npm run build && \
  cd /opt/app-root/src/ && mv app-builder/build /opt/app-builder && rm -rf app-builder && \
  chmod -R ug+rw /opt/app-builder

COPY --chown=1001:0 start.sh /opt/app-builder/start.sh
WORKDIR /opt/app-builder
CMD /opt/app-builder/start.sh
#because the npm serve package cannot make up its mind
EXPOSE 5000
ENV CLIENT_SECRET=appbuilder_secret
