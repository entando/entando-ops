#!/usr/bin/bash

# Install and build entando app
npm install && npm run build

#Execute serve
serve -l 3000 -s build