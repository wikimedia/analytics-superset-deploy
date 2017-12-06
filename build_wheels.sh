#!/bin/bash

# Install all dependencies into artifacts/$dist.  This should only be run
# on a build server.

# source common variables
source $(dirname $0)/profile.sh

sudo apt-get --yes install \
  python-pip \
  python-wheel \
  python-dev \
  build-essential \
  libssl-dev \
  libffi-dev \
  libsasl2-dev \
  libldap2-dev \
  libmysqlclient-dev


# If you update any requirements, you should also update this timestamp.
# This makes it more likely that wheels built with the same versions
# will be byte for byte identical.
export SOURCE_DATE_EPOCH=1512574740


rm -rf $wheels_dir
mkdir -p $wheels_dir

pip wheel -w $wheels_dir -r $(dirname $0)/frozen-requirements.txt
