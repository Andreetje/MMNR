FROM alpine:latest
MAINTAINER andre@jeanmaire.nl

# User data directory, contains flows, config and nodes.
RUN mkdir /data

RUN apk add --no-cache make g++ gcc openssl nodejs nodejs-npm python

RUN npm install -g --unsafe-perm node-red-admin
RUN npm install -g --unsafe-perm node-red
RUN npm install -g --unsafe-perm node-red-dashboard
RUN npm install -g --unsafe-perm node-red-contrib-opcua
RUN npm install -g --unsafe-perm mustache
RUN npm install -g --unsafe-perm mssql
RUN npm install -g --unsafe-perm node-red-contrib-mssql-plus
RUN npm install -g --unsafe-perm node-red-contrib-simpletime

RUN npm uninstall -g node-red-pi

#Oracle
ENV CLIENT_FILENAME instantclient-basic-linux.x64-12.1.0.1.0.zip
# work in this directory
WORKDIR /opt/oracle/lib
# take advantage of this repo to easily download the client (use it at your own risk)
ADD https://github.com/bumpx/oracle-instantclient/raw/master/${CLIENT_FILENAME} .
# we need libaio and libnsl, the latter is only available as package in the edge repository
RUN apk add --update libaio libnsl && \
    ln -s /usr/lib/libnsl.so.2 /usr/lib/libnsl.so.1

# unzip the necessary libraries, create the base symlink and remove the zip file
RUN LIBS="*/libociei.so */libons.so */libnnz12.so */libclntshcore.so.12.1 */libclntsh.so.12.1" && \
    unzip ${CLIENT_FILENAME} ${LIBS} && \
    for lib in ${LIBS}; do mv ${lib} /usr/lib; done && \
    ln -s /usr/lib/libclntsh.so.12.1 /usr/lib/libclntsh.so && \
    rm ${CLIENT_FILENAME}

VOLUME ["/data"]

ENTRYPOINT node-red --userDir /data
