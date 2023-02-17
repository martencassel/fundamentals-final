#!/bin/bash

cat <<EOF > ./ui/Dockerfile
FROM node:8-alpine
COPY . .
RUN npm install
CMD node src/server.js
EOF

docker build -t myui ./ui/ -f ./ui/Dockerfile
