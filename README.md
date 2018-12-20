To build and update this deploy repo, follow these steps.

  # Check changelog to spot db upgrades, etc..
  https://github.com/apache/incubator-superset/blob/master/UPDATING.md
  # Or https://github.com/wikimedia/incubator-superset/blob/wikimedia/UPDATING.md

  # First modify Superset's version in frozen-requirements.txt

  # Build the wheels into a temp virtualenv.
  ./build_wheels.sh

  # Commit and send it to review
  git add artifacts
  git commit -m 'Updating wheels for superset and dependencies'
  git review

Once merged, a virtualenv out of all files in artifacts/$dist will be
built during deployment. This is done by the create_virtualenv.sh script.
