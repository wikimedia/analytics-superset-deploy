dist=$(lsb_release --codename --short)
deploy_dir=$(dirname $0)
wheels_dir=$deploy_dir/artifacts/$dist

# Default deploy directory, should exist in production.
if [ -e /srv/deployment/analytics/superset ]; then
    venv=/srv/deployment/analytics/superset/venv
# Else just use ../superset-venv for testing.
else
    venv=$deploy_dir/../superset-venv
fi

# remove any existing virtualenv
rm -rfv $venv
mkdir -pv $venv

echo "Creating new virtualenv at $venv with wheels from $wheels_dir..."
# create a new virtualenv from wheels/
virtualenv --system-site-packages --never-download $venv
$venv/bin/pip install --no-index --find-links $wheels_dir --requirement $deploy_dir/frozen-requirements.txt
