FROM alpine:latest
MAINTAINER andre@jeanmaire.nl

# User data directory, contains flows, config and nodes.
RUN mkdir /data

RUN apk update
RUN apk add make g++ openssl nodejs nodejs-npm

RUN npm install -g --unsafe-perm bcryptjs
RUN npm install -g --unsafe-perm node-red
RUN npm install -g --unsafe-perm node-red-dashboard
RUN npm install -g --unsafe-perm node-red-contrib-opcua
RUN npm install -g --unsafe-perm mustache
RUN npm install -g --unsafe-perm mssql
RUN npm install -g --unsafe-perm node-red-contrib-mssql-plus
RUN npm install -g --unsafe-perm simpletime

RUN npm uninstall -g node-red-pi

VOLUME ["/data"]

ENTRYPOINT node-red --userDir /data
