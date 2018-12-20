To build and update this deploy repo, follow these steps.

  # Check changelog to spot db upgrades, etc..
  https://github.com/apache/incubator-superset/blob/master/UPDATING.md
  # Or https://github.com/wikimedia/incubator-superset/blob/wikimedia/UPDATING.md

NOTE:  We currently use a fork of superset. setup.py has
been patched to help with auto building.  It should be
safe to point superset in frozen-requirements.txt at
the git URL of our fork.  To update the wikimedia
deployment of superset, don't change frozen-requirements.txt.
Instead, update the wikimedia branch of incubator-superset
on github, and rebuild.  When you do, be sure to also
update the `version_string` in the setup.py file of the wikimedia branch.

  # Build the wheels into a temp virtualenv.
  ./build_wheels.sh

  # Commit and send it to review
  git add artifacts
  git commit -m 'Updating wheels for superset and dependencies'
  git review

Once merged, a virtualenv out of all files in artifacts/$dist will be
built during deployment. This is done by the create_virtualenv.sh script.
