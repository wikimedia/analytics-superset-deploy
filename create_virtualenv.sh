#!/bin/bash

set -ex

# source common variables
source $(dirname $0)/profile.sh

# remove any existing virtualenv
test -e $venv && echo "Deleting existent virtualenv at $venv" && rm -rf $venv
mkdir -pv $venv

echo "Creating new virtualenv at $venv with requirements from wheels in $wheels_dir..."
virtualenv --python python3 --never-download $venv
$venv/bin/pip install --no-index --find-links $wheels_dir --requirement $deploy_dir/frozen-requirements.txt
