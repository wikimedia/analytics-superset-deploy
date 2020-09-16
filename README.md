To build and update this deploy repo, follow these steps.

  # Check changelog to spot db upgrades, etc..
  https://github.com/apache/incubator-superset/blob/master/UPDATING.md
  # Or https://github.com/wikimedia/incubator-superset/blob/wikimedia/UPDATING.md

  # Update frozen-requirements.txt with the new version of superset
  # Run docker like the following:
  run --rm --volume $(pwd)/superset_deploy:/superset_deploy -it debian:buster bash

  # Build the wheels into a temp virtualenv.
  cd /superset_deploy
  ./prep_env_for_docker.sh
  ./build_wheels.sh

  # Test if the virtual environment is created without dependency errors
  ./create_virtualenv.sh
  
At this point, you can close the Docker container and return to the repo.

  # Commit and send it to review
  git add artifacts
  git commit -m 'Updating wheels for superset and dependencies'
  git review

Once merged, a virtualenv out of all files in artifacts/$dist will be
built during deployment. This is done by the create_virtualenv.sh script.
