# source common variables
source $(dirname $0)/profile.sh

# remove any existing virtualenv
rm -rfv $venv
mkdir -pv $venv

echo "Creating new virtualenv at $venv with wheels from $wheels_dir..."
# create a new virtualenv from wheels/
virtualenv --system-site-packages --never-download $venv
$venv/bin/pip install --no-index --find-links $wheels_dir --requirement $deploy_dir/frozen-requirements.txt
