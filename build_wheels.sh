#!/bin/bash

# Install all dependencies into artifacts/$dist.  This should only be run
# on a build server.

set -ex

# source common variables
source $(dirname $0)/profile.sh

requirements_file=${1:-frozen-requirements.txt}

sudo apt-get --yes install \
  python3-pip \
  python3-wheel \
  python3-dev \
  virtualenv \
  build-essential \
  libssl-dev \
  libffi-dev \
  libsasl2-dev \
  libldap2-dev \
  default-libmysqlclient-dev

# This will be set to the mtime of frozen-requirements.txt
# This makes it more likely that wheels built with the same versions
# will be byte for byte identical.
export SOURCE_DATE_EPOCH=$(stat -c %Y ${deploy_dir}/frozen-requirements.txt)

# Build in a virtualenv, but install wheel files to $wheels_dir.
build_venv=/tmp/superset-build-venv-${SOURCE_DATE_EPOCH}
test -e $build_venv && rm -rf $build_venv

/usr/bin/virtualenv --python python3 --system-site-packages $build_venv

# Remove any previously installed wheels.
rm -rf $wheels_dir
mkdir -p $wheels_dir

# Update pip to be able to install the manylinux2010 and later wheel format.
$build_venv/bin/pip install --upgrade pip==21.0.1
# Package pip itself as a wheel, so that pip can install the new wheels upon deployment
$build_venv/bin/pip wheel -w $wheels_dir pip==21.0.1
$build_venv/bin/pip wheel --trusted-host pypi.org --trusted-host files.pythonhosted.org -w $wheels_dir -r $deploy_dir/$requirements_file
