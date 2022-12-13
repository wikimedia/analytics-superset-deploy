To build and update this deploy repo, follow these steps.

Check changelog to spot db upgrades, etc..
https://github.com/apache/superset/blob/master/UPDATING.md

There are two ways to build the wheels used to deploy: using an upstream pypi release,
and using a local clone, which may have additional commits added by you or upstream.

### Using an upstream release

```sh
# Update frozen-requirements.txt with the new version of superset
# Run docker like the following on a build server:
docker run --rm --volume $(pwd)/:/superset_deploy --volume $(pwd)/superset_upstream:/superset_upstream -it docker-registry.wikimedia.org/bullseye:latest bash

cd /superset_deploy

# If running docker on deneb.codfw.wmnet, use a proxy:
# export http_proxy=http://webproxy.eqiad.wmnet:8080
# export https_proxy=http://webproxy.eqiad.wmnet:8080
./prep_env_for_docker.sh

# Build the wheels into a temp virtualenv.
# This uses frozen_requirements.txt and the upstream wheel
./build_wheels.sh

# Test if the virtual environment is created without dependency errors
./create_virtualenv.sh
```

### Using a local superset clone

```sh
# Clone and edit the superset repository such as the following
export http_proxy=http://webproxy.eqiad.wmnet:8080
export https_proxy=http://webproxy.eqiad.wmnet:8080
git clone https://github.com/apache/superset superset_upstream

# Run docker syncing superset_upstream:
docker run --rm --volume $(pwd)/:/superset_deploy --volume $(pwd)/superset_upstream:/superset_upstream -it docker-registry.wikimedia.org/bullseye:latest bash

# Use proxy for apt, otherwise apt-get update hangs when connecting to security.debian.org:80
echo 'Acquire::http::Proxy "http://webproxy.eqiad.wmnet:8080";' > /etc/apt/apt.conf
export http_proxy=http://webproxy.eqiad.wmnet:8080
export https_proxy=http://webproxy.eqiad.wmnet:8080
cd /superset_deploy

./prep_env_for_docker.sh

# Build the wheels into a temp virtualenv.
# First build the frontend:
./build_frontend.sh
# Then pass a requirements file with the superset directory as a dependency:
./build_wheels.sh frozen-requirements-custom-build.txt

# Test if the virtual environment is created without dependency errors
./create_virtualenv.sh
```

At this point, you can close the Docker container and return to the repo.

```sh
# Commit and send it to review
git add artifacts
git commit -m 'Updating wheels for superset and dependencies'
git review
```

Once merged, a virtualenv out of all files in artifacts/$dist will be
built during deployment. This is done by the create_virtualenv.sh script.
