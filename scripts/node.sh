#!/bin/bash

VERSION="node-v18.12.1-linux-x64"
NODE_DIR="/usr/local/lib/nodejs/"
NODE_VERSION_DIR="${NODE_DIR}${VERSION}/"
USER_BIN="$HOME/bin/"
if [ ! -d $NODE_DIR ] ; then
    sudo mkdir -p "$NODE_DIR"
    echo "Creating ${NODE_DIR}"
fi

if [ ! -d $NODE_DIR ] ; then
    mkdir -p "$NODE_DIR"
    curl -s some_url | tar xvz -C /tmp
    curl -s | sudo tar -xJvf $VERSION.tar.xz -C /usr/local/lib/nodejs
    echo Downloading node to $NODE_VERSION_DIR
fi

if [ ! -e "${USER_BIN}npm" ] ;then 
    bins=( npm npx node)
    for file in "${bins[@]}" ; do
    sudo ln -s "${NODE_VERSION_DIR}bin/${file}" "${USER_BIN}${file}"
    echo symlinking "${NODE_VERSION_DIR}bin/${file}" "${USER_BIN}${file}"
done
fi
