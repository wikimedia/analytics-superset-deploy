#!/bin/bash
# Helper script to install some dependencies for build_wheels.sh
# when building Superset with Docker.

set -xe

apt-get update
apt-get upgrade -y
apt-get install -y sudo lsb-release libkrb5-dev
