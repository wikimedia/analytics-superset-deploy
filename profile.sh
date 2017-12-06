# Common variables for build and deploy scripts.

deploy_dir=$(dirname $0)
dist=$(lsb_release --codename --short)
wheels_dir=$deploy_dir/artifacts/$dist

# Default deploy directory, should exist in production.
if [ -e /srv/deployment/analytics/superset ]; then
    venv=/srv/deployment/analytics/superset/venv
# Else just use ../superset-venv for testing.
else
    venv=$deploy_dir/../superset-venv
fi
