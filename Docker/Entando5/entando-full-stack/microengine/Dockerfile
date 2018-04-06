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
ENV DOMAIN //entando

# Install and configure `serve`.
RUN npm install -g serve
CMD serve -s build
EXPOSE 5000

# Download project from entando repository
RUN git clone https://github.com/entando/runtime-admin-app.git

WORKDIR runtime-admin-app

# Build for production.
RUN npm install && npm run build --production