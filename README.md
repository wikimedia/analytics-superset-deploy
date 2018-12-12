**************************************
      TEMPORARY PRE-STEP
**************************************

In 0.28.1+ Superset requires Python 3.6, that is not available
for Debian Stretch. Up to 0.28.1 there seems not to be specific
3.6 constructs (like f-strings) that will not work on 3.5, so
as a temporary measure we need to build our custom Superset wheel
reverting all the changes that are impactful:
- https://github.com/apache/incubator-superset/commit/160e47720cdfbe69e0cc8c0ecffc63b7c5ad0b72

Procedure to build the custom superset wheel:
- get the https://github.com/apache/incubator-superset repo
- run pypi_push.sh to build npm build (requires install first)
- run python3 setup.py sdist bdist_wheel

At this point, you'll have in dist/ a file named superset-0.28.1-py3-none-any.whl

Copy it to the superset scap repository, and start from build_wheels.sh as usual
(the script has been modified to grab superset-0.28.1-py3-none-any.whl).

***********************************
     REGULAR PROCEDURE
***********************************

To build/update this deploy repo, first use pip to install
all dependencies as wheels into the wheels/ directory. This
is done by the build_wheels.sh script.  Then make a commit
to include new files in artifacts/.

  ./build_wheels.sh
  git add artifacts
  git commit -m 'Updating wheels for superset and dependencies'
  git review

Once merged, a virtualenv out of all files in artifacts/$dist will be
built during deployment. This is done by the create_virtualenv.sh script.
