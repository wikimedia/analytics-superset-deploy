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

# Make sure nodesource is installed for nodejs 10.
# See: https://github.com/nodesource/distributions/blob/measter/README.md#deb
# These are needed to manually build our superset fork JS deps using webpack.
#
# # Using Debian, as root
# curl -sL https://deb.nodesource.com/setup_10.x | bash -
#
# We also need node yarn package manager, which conflicts with the
# installed by default 'cmdtest' package.
# See: https://github.com/yarnpkg/yarn/issues/2821
#
# # Using Debian, as root
# curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
# echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
# sudo apt update

sudo apt-get remove --yes cmdtest

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
  $libmysqlclient_dev_package \
  nodejs \
  yarn

# This will be set to the mtime of frozen-requirements.txt
# This makes it more likely that wheels built with the same versions
# will be byte for byte identical.
export SOURCE_DATE_EPOCH=$(stat -c %Y ${deploy_dir}/frozen-requirements.txt)

# Build in a virtualenv, but install wheel files to $wheels_dir.
build_venv=/tmp/superset-build-venv-${SOURCE_DATE_EPOCH}
test -e $build_venv && rm -rf $build_venv

# Rely on pip installed on the OS, to avoid issues with the one
# used by create_virtualenv.sh
# More info: https://phabricator.wikimedia.org/T236690#5697280
/usr/bin/virtualenv --python python3 --system-site-packages --no-pip $build_venv

# Remove any previously installed wheels.
rm -rf $wheels_dir
mkdir -p $wheels_dir

/usr/bin/pip3 wheel --trusted-host pypi.org --trusted-host files.pythonhosted.org -w $wheels_dir -r $deploy_dir/frozen-requirements.txt
