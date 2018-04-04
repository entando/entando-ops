# You should always specify a full version here to ensure all of your developers
# are running the same version of Node.
FROM node:8.9.4

# Override the base log level (info).
ENV NPM_CONFIG_LOGLEVEL warn

# Install and configure `serve`.
RUN npm install -g serve
CMD serve -s build
EXPOSE 5000

# Copy all local files into the image.
COPY . .

# Build for production.
RUN npm run build --production