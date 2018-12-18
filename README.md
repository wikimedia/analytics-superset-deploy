To build/update this deploy repo, first use pip to install
all dependencies as wheels into the wheels/ directory. This
is done by the build_wheels.sh script.  Then make a commit
to include new files in artifacts/.

  # Check changelog to spot db upgrades, etc..
  https://github.com/apache/incubator-superset/blob/master/UPDATING.md

  # Modify Superset's version in frozen-requirements.txt
  # Build
  ./build_wheels.sh
  # Commit and send it to review
  git add artifacts
  git commit -m 'Updating wheels for superset and dependencies'
  git review

Once merged, a virtualenv out of all files in artifacts/$dist will be
built during deployment. This is done by the create_virtualenv.sh script.
