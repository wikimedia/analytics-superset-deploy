#!/bin/bash

# Initialize superset.
# See: https://superset.incubator.apache.org/installation.html

set -ex

# source common variables
source $(dirname $0)/profile.sh

admin_user=${1:-admin}
admin_pass=${2:-admin}

# If /etc/superset exists, set PYTHONPATH so superset will load superset_config.py
test -e /etc/superset && export PYTHONPATH=/etc/superset
# SUPERSET_HOME should be /var/lib/superset if it exists.
test -e /var/lib/superset && export SUPERSET_HOME=/var/lib/superset


# Create a Flask admin user.
$venv/bin/fabmanager create-admin --app superset --username $admin_user --password $admin_pass --firstname Admin --lastname User --email analytics-alerts@wikimedia.org 

# Initialize the database
$venv/bin/superset db upgrade

# Create default roles and permissions
$venv/bin/superset init
