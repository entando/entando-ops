FROM node:9

# Override the base log level (info).
ENV NPM_CONFIG_LOGLEVEL warn

RUN npm install -g react-scripts \
&& npm install -g yarn \
&& git clone https://github.com/entando/assisted-demo-tool.git \
&& cd assisted-demo-tool \
&& yarn install \
&& yarn build \
&& chown -R node:0 /assisted-demo-tool/ && chmod -R ug+w /assisted-demo-tool/

WORKDIR assisted-demo-tool

CMD yarn start
EXPOSE 3000