#!/bin/bash
# Helper script to install some dependencies for build_wheels.sh
# when building Superset with Docker.

set -xe

export SUPERSET_VERSION=3.1.0

apt-get update
apt-get upgrade -y
apt-get install -y sudo lsb-release libkrb5-dev libmemcached-dev git ca-certificates curl

# n.b The following source download and verify is disabled because the checksums are currently wrong - See: https://github.com/apache/superset/issues/25333
# Download the superset source from Apache's repository and verify its authenticity
# curl --remote-name-all https://downloads.apache.org/superset/${SUPERSET_VERSION}/apache-superset-${SUPERSET_VERSION}-source.tar.gz
# curl --remote-name-all https://downloads.apache.org/superset/${SUPERSET_VERSION}/apache-superset-${SUPERSET_VERSION}-source.tar.gz.{asc,sha512}
# curl https://downloads.apache.org/superset/KEYS | gpg --import &&
#        gpg --verify apache-superset-${SUPERSET_VERSION}-source.tar.gz.asc
# cat apache-superset-${SUPERSET_VERSION}-source.tar.gz.sha512 | sha512sum --check --strict
# Extract the superset source
#tar xzvf apache-superset-${SUPERSET_VERSION}-source.tar.gz
cd /superset_deploy

git config --global --add safe.directory /superset_deploy

git clone --branch ${SUPERSET_VERSION} --single-branch https://github.com/apache/superset.git superset_upstream ||
( cd superset_upstream; git checkout ${SUPERSET_VERSION} )

# The following is a temporary workaround for the issues identifed in https://phabricator.wikimedia.org/T335356#9478404
# It can be removed as soon as https://github.com/apache/superset/pull/26782 is approved by the upstream project and released.
cd /superset_deploy/superset_upstream
curl https://github.com/brouberol/superset/commit/6cab1dcd13f0466f86e3e5139e7e3e0cbe5e58ae.patch | git apply -v --index
