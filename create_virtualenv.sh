#!/bin/bash

set -ex

# source common variables
source $(dirname $0)/profile.sh

# remove any existing virtualenv
test -e $venv && echo "Deleting existent virtualenv at $venv" && rm -rf $venv
mkdir -pv $venv

echo "Creating new virtualenv at $venv with all wheels in $wheels_dir..."
virtualenv --python python3 --never-download $venv
# Until Wikimedia started using a fork, we used -r frozen-requirements.txt
# to install superset and other requirements.  However, now that
# frozen-requirements.txt is pointing at the wikimedia github fork url,
# pip install with it will not be able to find superset in the wheels dir.
# Instead, just install all wheels in the wheels dir.

# First upgrade pip to pip-22 so that newer wheels will be supported
$venv/bin/pip install --no-index --force-reinstall --find-links $wheels_dir $wheels_dir/pip-23.2.1-py3-none-any.whl

$venv/bin/pip install --no-deps --no-index --find-links $wheels_dir $wheels_dir/*.whl
