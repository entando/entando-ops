#!/bin/bash

# Install and build entando app
npm install && npm run build --production

#Execute serve
serve -s build