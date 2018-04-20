# You should always specify a full version here to ensure all of your developers
# are running the same version of Node.
FROM node:9

# Override the base log level (info).
ENV NPM_CONFIG_LOGLEVEL warn

# Set entando Instance to query
#USE_MOCKS (boolean, default: true)
#a boolean used to determine whether the API calls will be against a real Entando Core or if they are just being mocked
#internally.
#
#DOMAIN (string, default: null)
#a string representing the domain name of the Entando Core instance. The protocol is optional and it is possible to
#specify a subdirectory of the domain. Trailing slashes are not valid and it only vaildates up to 3rd level domains.
#
#All the following would be valid values:
#
#http://my.entando.com
#https://my.entando.com
#//my.entando.com
#//my.entando.com/entando-sample

ENV USE_MOCKS false
ENV DOMAIN //127.0.0.1.nip.io:8080/entando

COPY start.sh /start.sh

# Install and configure `serve`. Download project from entando repository
RUN npm install -g serve \
&& chmod a+x /start.sh \
&& git clone https://github.com/entando/app-builder.git \
&& chown -R node:0 /app-builder/ && chmod -R ug+w /app-builder/

USER node

WORKDIR app-builder

CMD /start.sh >> /dev/null
EXPOSE 5000