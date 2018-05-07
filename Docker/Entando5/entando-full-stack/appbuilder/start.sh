#!/bin/bash

# Install and build entando app
npm install && npm run import-plugins && npm run build

#Execute serve
serve -s build