#!/bin/bash

# Install all dependencies into artifacts/$dist.  This should only be run
# on a build server.

set -ex

# source common variables
source $(dirname $0)/profile.sh

# Choose name for libmysqlclient-dev based on distribution name.
if [ "${dist}" == "jessie" ]; then
    libmysqlclient_dev_package='libmysqlclient-dev'
else
    libmysqlclient_dev_package='default-libmysqlclient-dev'
fi

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
  $libmysqlclient_dev_package

# If you update any requirements, you should also update this timestamp.
# This makes it more likely that wheels built with the same versions
# will be byte for byte identical.
export SOURCE_DATE_EPOCH=1534958257

rm -rf $wheels_dir
mkdir -p $wheels_dir



# Build in a virtualenv, but install wheel files to $wheels_dir.
build_venv=/tmp/superset-build-venv
test -e $build_venv && rm -rf $build_venv
virtualenv --python python3 --system-site-packages $build_venv

# Weird bug where numpy needs to be installed before pandas is built.
# https://github.com/pandas-dev/pandas/issues/16715#issuecomment-309498415
# Build this wheel first and install it into our build virtualenv.
# This will let pandas build against the version of numpy that we will
# actually install.
$build_venv/bin/pip wheel -w $wheels_dir numpy
$build_venv/bin/pip install --no-index --find-links $wheels_dir numpy
$build_venv/bin/pip wheel --trusted-host pypi.org --trusted-host files.pythonhosted.org -w $wheels_dir -r $deploy_dir/frozen-requirements.txt
