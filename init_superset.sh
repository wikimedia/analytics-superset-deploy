# source common variables
source $(dirname $0)/profile.sh

admin_user=${1:-admin}
admin_pass=${2:-admin}

# If /etc/superset exists, assume that superset configs are here.
# Putting this directory in PYTHONPATH will make superset use them.
test -e /etc/superset && export PYTHONPATH=/etc/superset

# Initialize superset.
# See: https://superset.incubator.apache.org/installation.html

# Create a Flask admin user.
$venv/bin/fabmanager create-admin --app superset --username $admin_user --password $admin_pass --firstname Admin --lastname User --email analytics-alerts@wikimedia.org 

# Initialize the database
$venv/bin/superset db upgrade

# Create default roles and permissions
$venv/bin/superset init
