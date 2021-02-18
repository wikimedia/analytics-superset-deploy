#!/bin/bash
# See README.md for usage
#
set -ex

apt-get update
apt-get install -y curl ca-certificates gpg

# Taken from https://deb.nodesource.com/setup_14.x
keyring='/usr/share/keyrings'
node_key_url='https://deb.nodesource.com/gpgkey/nodesource.gpg.key'
local_node_key="$keyring/nodesource.gpg"
curl -s $node_key_url | gpg --dearmor | tee $local_node_key >/dev/null
echo "deb [signed-by=$local_node_key] https://deb.nodesource.com/node_14.x buster main" > /etc/apt/sources.list.d/nodesource.list
echo "deb-src [signed-by=$local_node_key] https://deb.nodesource.com/node_14.x buster main" >> /etc/apt/sources.list.d/nodesource.list

apt-get update
apt-get install -y nodejs

# Use the same npm version as superset expects
# See https://github.com/apache/superset/blob/master/superset-frontend/package.json#L60
npm install --global npm@7.5.4

cd /superset_upstream/superset-frontend
npm ci
npm run build
